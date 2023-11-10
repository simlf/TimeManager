<script setup lang="ts">
import { ref } from 'vue'
import { Bar, Doughnut } from 'vue-chartjs'
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
  ArcElement
} from 'chart.js'
import {useAuthStore} from "@/stores/auth.store";
import moment from 'moment'
import axios from 'axios'
import { useRoute } from 'vue-router';
import ChartTest from './ChartTest.vue';
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)

</script>

<script lang="ts">
const authStore = useAuthStore()
const defaultUserId = authStore.id

const isManager = authStore.isManager || authStore.isSuperManager
// const isManager = false

// const dateValue = ref([])
let workingTimesRef = ref()
let workingTimesRefDoughnut = ref()

function dDate(date: object) {
  return date > new Date()
}

const formatter = ref({
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

// localStorage.clear()
// console.log(localStorage.getItem('start'))

const start = ref(localStorage.getItem('start') || getLastMonday())
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))
const dateValue = ref([start.value, end.value]);

const chartDataTest = [
  {
    "total_hours": 7.45,
    "total_break": 0.25,
    "start_time": "2023-11-06 09:34",
    "end_time": "2023-11-06 17:34"
  },
  {
    "total_hours": 6.5,
    "total_break": 0.5,
    "start_time": "2023-11-07 08:45",
    "end_time": "2023-11-07 15:15"
  },
  {
    "total_hours": 8.0,
    "total_break": 0.75,
    "start_time": "2023-11-08 10:00",
    "end_time": "2023-11-08 18:00"
  },
  {
    "total_hours": 6.30,
    "total_break": 0.45,
    "start_time": "2023-11-10 11:00",
    "end_time": "2023-11-10 17:50"
  }
];

const labelsx = ['Worked Time', 'Break Time']
const datasets= [
  {
    label: 'Working Hours',
    backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
    // borderColor: 'rgba(75, 192, 192, 1)',
    // borderWidth: 1,
    // data: [],
    data: [10, 20, 30, 5], // Données de test par défaut
    stack: "Stack 0",
  }
]

const yourChartData = ref(datasets);
const labels = ref(labelsx);

export default {
  name: 'BarChart',
  components: { Bar, Doughnut },
  data() {
    return {
      chartDataDoughnut: {
        labels: ['Worked Time', 'Break Time'],
        datasets: [
          {
            // label: 'Worked Time',
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            data: [25, 30 ]
          }
        ]
      },
      chartData: {
        labels: ['t1', 't2', 't3', 't4'],
        datasets: [
          {
            label: 'Working Hours',
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            // borderColor: 'rgba(75, 192, 192, 1)',
            // borderWidth: 1,
            // data: [],
            data: [10, 20, 30, 5], // Données de test par défaut
            stack: "Stack 0",
          }
        ]
      },
      selectedUserId: useRoute().params.userId || defaultUserId,
    }
  },
  computed: {
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
            // text: 'Hours Worked'
          }
        }
      }
    }
  },
  created() {
    this.getWorkingTimes();
    // this.updateCalendar()
  },
  methods: {
    async getWorkingTimes() {

      localStorage.setItem('start', start.value);  
      localStorage.setItem('end', end.value);

      start.value += '%2000:00:00'
      end.value += '%2023:59:59'
      const requestUrl = `http://localhost:4000/api/workingtimes/${this.selectedUserId}?start_time=${start.value}&end_time=${end.value}`

      // console.log(requestUrl)

      workingTimesRefDoughnut.value = chartDataTest
      workingTimesRef.value = chartDataTest
      this.updateChartData()

      return
      // this.updateChartData()

      console.log(workingTimesRefDoughnut)

      try {
        const response = await axios.get(requestUrl)
        const data = response.data
        workingTimesRef.value = data.data

        console.log(data)

        // Mise à jour du graphique
        this.updateChartData()
      } catch (error) {
        console.error('Erreur API', error)
      }
    },
    updateChartData() {
      this.chartData.labels = chartDataTest.map((item) =>
        moment(item.start_time).format('YYYY-MM-DD')
      );
      this.chartData.datasets = [
        {
          label: 'Total Time',
          data: chartDataTest.map((item) => item.total_hours),
          backgroundColor: ['#41B883'],
          stack: 'Stack 0', 
        },
        {
          label: 'Break Time',
          data: chartDataTest.map((item) => item.total_break),
          backgroundColor: ['#E46651'],
          stack: 'Stack 0', 
        },
      ];

      const totalHoursAndBreak = chartDataTest.reduce((acc, item) => {
        acc.total_hours += item.total_hours;
        acc.total_break += item.total_break;
        return acc;
      }, { total_hours: 0, total_break: 0 });

      this.chartDataDoughnut.datasets[0].data = [totalHoursAndBreak.total_hours, totalHoursAndBreak.total_break];

      yourChartData.value = this.chartData.datasets
      labels.value = this.chartData.labels

      this.triggerChartDataUpdate()
      this.triggerChartDataDoughnutUpdate()
    },
    handleDateClick(modelData: Array<string>) {
      [start.value, end.value] = modelData;

      this.getWorkingTimes()
    },
    triggerChartDataUpdate() {
      this.chartData = {
        ...this.chartData,
        datasets: [...this.chartData.datasets],
        labels: [...this.chartData.labels]
      }
    },
    triggerChartDataDoughnutUpdate() {
      this.chartDataDoughnut = {
        ...this.chartDataDoughnut,
        datasets: [...this.chartDataDoughnut.datasets],
        labels: [...this.chartDataDoughnut.labels]
      }
    },
  }
}

function getLastMonday() {
  const today = moment();
  const dayOfWeek = today.day(); // Récupérez le jour de la semaine actuel (0 = dimanche, 1 = lundi, ..., 6 = samedi)

  if (dayOfWeek === 1) {
    return today.format('YYYY-MM-DD');
  } else {
    const daysUntilLastMonday = (dayOfWeek + 6) % 7;
    const lastMonday = today.subtract(daysUntilLastMonday, 'days');
    return lastMonday.format('YYYY-MM-DD');
  }

}

const tabs = [
  { name: 'Default View', href: '/workingTimes/', current: true, hidden: false },
  { name: 'Manager View', href: '/workingTimesManager/', current: false, hidden: !isManager },
  { name: 'SuperManager View', href: '/workingTimesSuperManager/', current: false, hidden: !authStore.isSuperManager },
]

</script>

<template>  
<!-- <ChartTest :chartDataProp="yourChartData" :labelsProp="labels"  ></ChartTest> -->
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">

    <div v-if="isManager">

      <div class="relative border-b border-gray-200 pb-5 sm:pb-0">
        <div class="md:flex md:items-center md:justify-between">
          <!-- <h3 class="text-base font-semibold leading-6 text-gray-900">User View</h3> -->
        </div>
        <div class="mt-4">
          <div class="sm:hidden">
            <label for="current-tab" class="sr-only">Select a tab</label>
            <select id="current-tab" name="current-tab" class="block w-full rounded-md border-0 py-1.5 pl-3 pr-10 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600">
            <option v-for="tab in tabs" :key="tab.name" :selected="tab.current" :hidden="tab.hidden">{{ tab.name }}</option>
          </select>
        </div>
        <div class="hidden sm:block">
          <nav class="-mb-px flex space-x-8">
            <a v-for="tab in tabs" :key="tab.name" :href="tab.href" :hidden="tab.hidden" :class="[tab.current ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700', 'whitespace-nowrap border-b-2 px-1 pb-4 text-sm font-medium']" :aria-current="tab.current ? 'page' : undefined">{{ tab.name }}</a>
          </nav>
          </div>
        </div>
      </div>
    </div>

  <!-- Calendar / dashboard -->
  <div class="lg:w-96 mx-auto mt-2">
    <vue-tailwind-datepicker
      as-single
      use-range
      i18n="fr"
      v-model="dateValue"
      :disable-date="dDate"
      :formatter="formatter"
      @update:model-value="handleDateClick"
    />
  </div>
  <div class="md:flex md:items-center md:justify-center">

  <div class="md:w-1/3 mx-1 mt-2">
    <Doughnut id="my-doughnut-chart-id" :data="chartDataDoughnut" :options="chartOptions" ref="doughnut" />
  </div>
  <div class="md:w-1/3 mx-1 mt-2">
    <Bar id="my-chart-id" :data="chartData" :options="chartOptions" ref="bar" />
  </div>
</div>



  <!-- Table group users -->
  <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <!-- <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Groups
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all the users in your group including their username, email and role.
        </p> -->
      </div>
    </div>
    <div class="-mx-4 mt-8 sm:-mx-0">
      <table class="min-w-full divide-y divide-gray-300">
        <thead>
          <tr>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Date
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Start Time
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              End Time
            </th>

            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Worked Time
            </th>

            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Break Time
            </th>
            
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr v-for="(time, index) in workingTimesRef" :key="index" class="even:bg-gray-50">
            <td class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0">
              <div class="flex items-center">
                {{ moment(time.start_time).utc(false).format('YYYY-MM-DD') }}
                <dl class="font-normal lg:hidden">
                  <dt class="sr-only">Title</dt>
                </dl>
              </div>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ moment(time.start_time).utc(false).format('HH:mm') }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Title</dt>
              </dl>
            </td>
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ moment(time.end_time).utc(false).format('HH:mm') }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Hours worked</dt>
              </dl>
            </td>
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ time.total_hours}}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Hours worked</dt>
              </dl>
            </td>
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ time.total_break}}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Hours worked</dt>
              </dl>
            </td>
            
          </tr>
        </tbody>
      </table>
    </div>
        </div>
</template>

<style scoped></style>
