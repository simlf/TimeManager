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
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)

</script>

<script lang="ts">
const authStore = useAuthStore()
const defaultUserId = authStore.id

const isManager = authStore.isManager || authStore.isSuperManager
let workingTimesRef = ref()
let totalHoursRef = ref()

const start = ref(localStorage.getItem('start') || getLastMonday())
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))
const dateValue = ref([start.value, end.value]);

const noData = ref(false)

function dDate(date: object) {
  return date > new Date()
}

const formatter = ref({
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

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
        maintainAspectRatio: true,
        plugins: {
          title: {
            display: true,
            // text: 'Hours Worked'
          }
        },
        height: 400
      }
    }
  },
  created() {
    this.getWorkingTimes();
  },
  methods: {
    async getWorkingTimes() {

      localStorage.setItem('start', start.value);  
      localStorage.setItem('end', end.value);

      start.value += '%2000:00:00'
      end.value += '%2023:59:59'
      const requestUrl = `http://localhost:4000/api/times/info/${this.selectedUserId}?start_time=${start.value}&end_time=${end.value}`

      try {
        const response = await axios.get(requestUrl)
        const data = response.data.data
        workingTimesRef.value = data.dateList

        console.log(data)

        totalHoursRef.value = [data.timeWork.hours, data.timePause.hours]

        noData.value = false

        // Mise à jour du graphique
        this.updateChartData()
      } catch (error) {

        if (error.code == "ERR_BAD_RESPONSE") {
          noData.value = true
          
        }

        console.error('Erreur API', error)
      }
    },
    updateChartData() {
      this.chartData.labels = workingTimesRef.value.map((item) =>
        moment(item.date).format('YYYY-MM-DD')
      );
      this.chartData.datasets = [
        {
          label: 'Worked Time',
          data: workingTimesRef.value.map((item) => item.hours_work),
          backgroundColor: ['#41B883'],
          stack: 'Stack 0', 
        },
        {
          label: 'Break Time',
          data: workingTimesRef.value.map((item) => item.hours_pause),
          backgroundColor: ['#E46651'],
          stack: 'Stack 0', 
        },
      ];

      this.chartDataDoughnut.datasets[0].data = totalHoursRef
      this.triggerChartsDataUpdate()
    },
    handleDateClick(modelData: Array<string>) {
      // Si on clique sur "this month", le sélecteur outrepasse la règle dDate
      if (new Date(modelData[1]) > new Date()) {
        const today_date_str = moment().format('YYYY-MM-DD')
        modelData[1] = today_date_str
      }

      [start.value, end.value] = modelData;

      this.getWorkingTimes()
    },
    triggerChartsDataUpdate() {
      this.chartData = {
        ...this.chartData,
        datasets: [...this.chartData.datasets],
        labels: [...this.chartData.labels]
      },
      this.chartDataDoughnut = {
        ...this.chartDataDoughnut,
        datasets: [...this.chartDataDoughnut.datasets],
        labels: [...this.chartDataDoughnut.labels]
      }
      
    },
    formatHoursMinutes(decimalHours: number): string {
      // Diviser les heures et les minutes
      const hours = Math.floor(decimalHours);
      const minutes = Math.round((decimalHours - hours) * 60);

      return `${hours} hours ${minutes} minutes`;
    }

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
<!-- <ChartTest :chartDataProp="yourChartData" :labelsProp="labels" ref="chartTestComponent"  ></ChartTest> -->
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

  <div v-if="!noData">
    <div class="md:flex md:items-center md:justify-center">

      <div class="md:w-1/3 mx-1 mt-2">
        <Doughnut id="my-doughnut-chart-id" :data="chartDataDoughnut" :options="chartOptions" ref="doughnut" />
      </div>
      <div class="md:w-2/3 mx-1 mt-2 h-full">
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
            <!-- <th
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
            </th> -->

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
                {{ time.date }}
                <dl class="font-normal lg:hidden">
                  <dt class="sr-only">Date</dt>
                </dl>
              </div>
            </td>

            <!-- <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ moment(time.start_time).utc(false).format('HH:mm') }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Start Time</dt>
              </dl>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ moment(time.end_time).utc(false).format('HH:mm') }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">End Time</dt>
              </dl>
            </td> -->

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ formatHoursMinutes(time.hours_work) }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Worked Time</dt>
              </dl>
            </td>
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ formatHoursMinutes(time.hours_pause) }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Break Time</dt>
              </dl>
            </td>
            
          </tr>
        </tbody>
      </table>
    </div>
  
  </div>

  <div v-else class="md:flex md:items-center md:justify-center mt-5">
    <h1>No data to display for selected dates</h1>
  </div>
</div>

  

</template>

<style scoped></style>
