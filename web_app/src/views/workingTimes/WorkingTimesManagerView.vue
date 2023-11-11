<script setup lang="ts">
import { ref } from 'vue'
import { Doughnut } from 'vue-chartjs'
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
import { useAuthStore } from '@/stores/auth.store'
import moment from 'moment'
import axios from 'axios'
import { useRoute } from 'vue-router';
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)
</script>

<script lang="ts">
const authStore = useAuthStore()
const defaultGroupId = authStore.user.groupId

// const dateValue = ref([])
let workingTimesRef = ref()
let workingTimesRefUsers = ref()

function dDate(date: object) {
  return date > new Date()
}

const formatter = ref({
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

const start = ref(localStorage.getItem('start') || getLastMonday())
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))

const dateValue = ref([start.value, end.value])

const chartDataTest = [
  {
    username: "Jean",
    userId: 33,
    total_hours: 7.45,
  },
  {
    username: "Martin",
    userId: 23,
    total_hours: 6.5,
  },
  {
    username: "Pierre",
    userId: 34,
    total_hours: 8.0,
  },
  {
    username: "John",
    userId: 13,
    total_hours: 7.10,
  }
]

workingTimesRefUsers.value = chartDataTest

export default {
  name: 'DonutChart',
  components: { Doughnut },
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
      selectedGroupId: useRoute().params.groupId || defaultGroupId,
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
            text: 'Group Hours'
          }
        }
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
      const requestUrl = `http://localhost:4000/api/workingtimes/${this.selectedGroupId}?start_time=${start.value}&end_time=${end.value}`

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
      this.chartData.labels = chartDataTest.map((item) => item.username)
      this.chartData.datasets[0].data = chartDataTest.map((item) => item.total_hours)

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
    }
  }
}

function getLastMonday() {
  const today = moment()
  const dayOfWeek = today.day() // Récupérez le jour de la semaine actuel (0 = dimanche, 1 = lundi, ..., 6 = samedi)

  if (dayOfWeek === 1) {
    return today.format('YYYY-MM-DD')
  } else {
    const daysUntilLastMonday = (dayOfWeek + 6) % 7
    const lastMonday = today.subtract(daysUntilLastMonday, 'days')
    return lastMonday.format('YYYY-MM-DD')
  }
}

const tabs = [
  { name: 'Default View', href: '/workingTimes/', current: false, hidden: false },
  { name: 'Manager View', href: '/workingTimesManager/', current: true, hidden: false },
  { name: 'SuperManager View', href: '/workingTimesSuperManager', current: false, hidden: !authStore.isSuperManager },
]

function getInitials(username: string): string {
  return username
    .split(' ')
    .map((username) => username[0])
    .join('')
    .toUpperCase()
}
</script>

<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">

    <!-- Manager navbar -->
    
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
              Avatar
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Name
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Hours worked
            </th>
            
            <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-0">
              <span class="sr-only">Check user</span>
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr v-for="person in chartDataTest" :key="person.userId" class="even:bg-gray-50">
            <td class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0">
              <div class="flex items-center">
                <div
                  class="bg-indigo-500 flex w-10 h-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-medium text-white md:w-12 md:h-12"
                >
                  {{ getInitials(person.username) }}
                </div>
              </div>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ person.username }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Title</dt>
              </dl>
            </td>
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ person.total_hours }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Hours worked</dt>
              </dl>
            </td>


            <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
              <td class="px-6 py-4"><RouterLink :to="'/workingTimes/' + person.userId">
                <button
                class="text-indigo-600 hover:text-indigo-900"
              >
                Check user
              </button></RouterLink></td>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped></style>
