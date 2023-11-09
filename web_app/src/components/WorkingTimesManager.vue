<script setup lang="ts">
import { ref } from 'vue'
import { Bar, Doughnut, Pie } from 'vue-chartjs'
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
import WorkingTimesUser from './WorkingTimesUser.vue';
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)

</script>

<script lang="ts">
const authStore = useAuthStore()
const selectedUserId = ref(authStore.id)

// const roles = authStore.user!.roles!
const roles = ["MANAGER"]

// const dateValue = ref([])
let workingTimesRef = ref()
let workingTimesRefUsers = ref()

function dDate(date: object) {
  return date > new Date()
}

const formatter = ref({
  // date: 'DD-MM-YYYY',
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

// localStorage.clear()

const lastMonday = getLastMonday();
const start = ref(localStorage.getItem('start') || lastMonday)
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))

const dateValue = ref([start.value, end.value]);

const currentView = ref("Manager View")
const buttonText = ref("Default View")

const chartDataTest = [
  {
    "username": "Jean",
    "userId": 33,
    "total_hours": 7.45,
  },
  {
    "username": "Martin",
    "userId": 23,
    "total_hours": 6.5,
  },
  {
    "username": "Pierre",
    "userId": 34,
    "total_hours": 8.0,
  },
  {
    "username": "John",
    "userId": 13,
    "total_hours": 7.10,
  }
];

workingTimesRefUsers.value = chartDataTest

export default {
  name: 'BarChart',
  components: { Bar, Doughnut, WorkingTimesUser },
  setup() {
    const route = useRoute();
    const userId = route.params.id;

    console.log(userId)

  },
  data() {
    return {
      chartData: {
        labels: ['Jean', 'Martin', 'Pierre', 'John'],
        datasets: [
          {
            label: 'Doughnut Chart',
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            data: [25, 30, 15, 10]
          }
        ]
      },
      
      // userId: selectedUserId,
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
            text: 'Group Hours Worked'
          }
        }
      }
    }
  },
  created() {
    // this.getWorkingTimes();
  },
  methods: {
    async getWorkingTimes(
      // start: string = '2023-11-01%',
      // end: string = moment().format('YYYY-MM-DD') + "%"
    ) {
      localStorage.setItem('start', start.value);  
      localStorage.setItem('end', end.value);

      start.value += '%2000:00:00'
      end.value += '%2023:59:59'
      const requestUrl = `http://localhost:4000/api/workingtimes/${selectedUserId.value}?start_time=${start.value}&end_time=${end.value}`

      console.log(requestUrl)

      // workingTimesRefDoughnut.value = chartDataTest
      workingTimesRef.value = chartDataTest
      this.updateChartData()

      return
      
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
      this.chartData.labels = chartDataTest.map((item) => item.username);
      this.chartData.datasets[0].data = chartDataTest.map((item) => item.total_hours);
      
      this.triggerChartDataUpdate()
    },
    handleDateClick(modelData: Array<string>) {
      start.value = modelData[0]
      end.value = modelData[1]

      this.getWorkingTimes()
    },
    triggerChartDataUpdate() {
      this.chartData = {
        ...this.chartData,
        datasets: [...this.chartData.datasets],
        labels: [...this.chartData.labels]
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
  { name: 'Default View', href: '/workingTimes/', current: false },
  { name: 'Manager View', href: '#', current: true },
]
</script>

<template>
  <div class="relative border-b border-gray-200 pb-5 sm:pb-0">
      <div class="md:flex md:items-center md:justify-between">
        <!-- <h3 class="text-base font-semibold leading-6 text-gray-900">{{currentView}}</h3> -->
        
      </div>
      <div class="mt-4">
        <div class="sm:hidden">
          <label for="current-tab" class="sr-only">Select a tab</label>
          <select id="current-tab" name="current-tab" class="block w-full rounded-md border-0 py-1.5 pl-3 pr-10 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600">
            <option v-for="tab in tabs" :key="tab.name" :selected="tab.current">{{ tab.name }}</option>
          </select>
        </div>
        <div class="hidden sm:block">
          <nav class="-mb-px flex space-x-8">
            <a v-for="tab in tabs" :key="tab.name" :href="tab.href" :class="[tab.current ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700', 'whitespace-nowrap border-b-2 px-1 pb-4 text-sm font-medium']" :aria-current="tab.current ? 'page' : undefined">{{ tab.name }}</a>
          </nav>
        </div>
      </div>
    </div>

  <div class="md:flex md:items-center md:justify-center">
    <div class="md:w-1/3">
      <div class="mx-1 mt-2">
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

      <!-- chart du nb d'heure de chaque user du groupe -->
      <div class="mt-2">
        <Doughnut id="managerUsersDonut" :data="chartData" :options="chartOptions" ref="doughnut" />
      </div>
      
      <!-- tableau de chaque user du groupe -->
      <div class="relative overflow-x-auto">
        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead
            class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
          >
            <tr>
              <th scope="col" class="px-6 py-3">User</th>
              <th scope="col" class="px-6 py-3">Total Hours Worked</th>
              <th scope="col" class="px-6 py-3">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr
              class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
              v-for="(user, index) in workingTimesRefUsers"
              :key="index"
            >
              <td class="px-6 py-4">{{ user.username }}</td>
              <td class="px-6 py-4">{{ user.total_hours }}</td>
              <td class="px-6 py-4"><RouterLink :to="'/workingTimes/' + user.userId">Check user</RouterLink></td>

            </tr>
          </tbody>
        </table>
      </div>
    </div>      
  </div>
</template>

<style scoped></style>
