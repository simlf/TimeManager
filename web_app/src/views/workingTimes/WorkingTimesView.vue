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
import { useAuthStore } from '@/stores/auth.store'
import moment from 'moment'
import axios from 'axios'
import { useRoute } from 'vue-router'
import WorkingTimesUser from './WorkingTimesUserView.vue'
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale, ArcElement)
</script>

<script lang="ts">
const authStore = useAuthStore()
const selectedUserId = ref(authStore.id)

// const roles = authStore.user!.roles!
const roles = ['MANAGER']

// const dateValue = ref([])
let workingTimesRef = ref()
let workingTimesRefUsers = ref()
let workingTimesRefDoughnut = ref()

function dDate(date: object) {
  return date > new Date()
}

const formatter = ref({
  // date: 'DD-MM-YYYY',
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

// localStorage.clear()
// console.log(localStorage.getItem('start'))

const start = ref(localStorage.getItem('start') || getLastMonday())
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))
const dateValue = ref([start.value, end.value])
// const start = ref()
// const end = ref()
// const dateValue = ref()

const chartDataTest = [
  {
    total_hours: 7.45,
    total_break: 0.25,
    start_time: '2023-11-06 09:34',
    end_time: '2023-11-06 17:34'
  },
  {
    total_hours: 6.5,
    total_break: 0.5,
    start_time: '2023-11-07 08:45',
    end_time: '2023-11-07 15:15'
  },
  {
    total_hours: 8.0,
    total_break: 0.75,
    start_time: '2023-11-08 10:00',
    end_time: '2023-11-08 18:00'
  }
]

export default {
  name: 'BarChart',
  components: { Bar, Doughnut, WorkingTimesUser },
  setup() {
    const route = useRoute()
    const userId = route.params.id

    console.log(userId)
  },
  data() {
    return {
      chartDataDoughnut: {
        labels: ['Worked Time', 'Break Time'],
        datasets: [
          {
            // label: 'Worked Time',
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            data: [25, 30]
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
            stack: 'Stack 0'
          }
        ]
      },
      userId: selectedUserId
    }
  },
  computed: {
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true
            // text: 'Hours Worked'
          }
        }
      }
    }
  },
  created() {
    this.getWorkingTimes()
    // this.updateCalendar()
  },
  methods: {
    async getWorkingTimes() {
      localStorage.setItem('start', start.value)
      localStorage.setItem('end', end.value)

      start.value += '%2000:00:00'
      end.value += '%2023:59:59'
      const requestUrl = `http://localhost:4000/api/workingtimes/${selectedUserId.value}?start_time=${start.value}&end_time=${end.value}`

      // console.log(requestUrl)

      workingTimesRefDoughnut.value = chartDataTest
      workingTimesRef.value = chartDataTest
      this.updateChartData()

      return
      // this.updateChartData()

      console.log(workingTimesRefDoughnut)
      // afficher un tableau de chaque jours sélectionnés dans le tableau
      // date - starttime - endtime - hours worked

      // faire un donut/pie chart avec la somme total pour la période sélectionné de hours worked/pause/overtime

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
    // updateCalendar() {
    //    start.value = localStorage.getItem('start') || getLastMonday()
    //    end.value = localStorage.getItem('end') || moment().format('YYYY-MM-DD')
    //    dateValue.value = [start.value, end.value];
    // },
    updateChartData() {
      this.chartData.labels = chartDataTest.map((item) =>
        moment(item.start_time).format('YYYY-MM-DD')
      )
      this.chartData.datasets = [
        {
          label: 'Total Time',
          data: chartDataTest.map((item) => item.total_hours),
          backgroundColor: ['#41B883'],
          stack: 'Stack 0'
        },
        {
          label: 'Break Time',
          data: chartDataTest.map((item) => item.total_break),
          backgroundColor: ['#E46651'],
          stack: 'Stack 0'
        }
      ]

      const totalHoursAndBreak = chartDataTest.reduce(
        (acc, item) => {
          acc.total_hours += item.total_hours
          acc.total_break += item.total_break
          return acc
        },
        { total_hours: 0, total_break: 0 }
      )

      this.chartDataDoughnut.datasets[0].data = [
        totalHoursAndBreak.total_hours,
        totalHoursAndBreak.total_break
      ]

      this.triggerChartDataUpdate()
      this.triggerChartDataDoughnutUpdate()
    },
    handleDateClick(modelData: Array<string>) {
      ;[start.value, end.value] = modelData

      console.log(start.value)

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
  { name: 'Default View', href: '#', current: true },
  { name: 'Manager View', href: '/workingTimesManager/', current: false }
]
</script>

<template>
  <div v-if="roles.includes('MANAGER')">
    <div class="relative border-b border-gray-200 pb-5 sm:pb-0">
      <div class="md:flex md:items-center md:justify-between">
        <!-- <h3 class="text-base font-semibold leading-6 text-gray-900">User View</h3> -->
      </div>
      <div class="mt-4">
        <div class="sm:hidden">
          <label for="current-tab" class="sr-only">Select a tab</label>
          <select
            id="current-tab"
            name="current-tab"
            class="block w-full rounded-md border-0 py-1.5 pl-3 pr-10 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600"
          >
            <option v-for="tab in tabs" :key="tab.name" :selected="tab.current">
              {{ tab.name }}
            </option>
          </select>
        </div>
        <div class="hidden sm:block">
          <nav class="-mb-px flex space-x-8">
            <a
              v-for="tab in tabs"
              :key="tab.name"
              :href="tab.href"
              :class="[
                tab.current
                  ? 'border-indigo-500 text-indigo-600'
                  : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700',
                'whitespace-nowrap border-b-2 px-1 pb-4 text-sm font-medium'
              ]"
              :aria-current="tab.current ? 'page' : undefined"
              >{{ tab.name }}</a
            >
          </nav>
        </div>
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
      <div>
        <Doughnut
          id="my-doughnut-chart-id"
          :data="chartDataDoughnut"
          :options="chartOptions"
          ref="doughnut"
        />
      </div>

      <div>
        <Bar id="my-chart-id" :data="chartData" :options="chartOptions" ref="bar" />
      </div>
      <div class="relative overflow-x-auto">
        <table class="table-auto w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead
            class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
          >
            <tr>
              <th scope="col" class="px-6 py-3">Date</th>
              <th scope="col" class="px-6 py-3">Start Time</th>
              <th scope="col" class="px-6 py-3">End Time</th>
              <th scope="col" class="px-6 py-3">Worked Time</th>
              <th scope="col" class="px-6 py-3">Break Time</th>
            </tr>
          </thead>
          <tbody>
            <tr
              class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
              v-for="(time, index) in workingTimesRef"
              :key="index"
            >
              <td class="px-6 py-4">
                {{ moment(time.start_time).utc(false).format('YYYY-MM-DD') }}
              </td>
              <td class="px-6 py-4">{{ moment(time.start_time).utc(false).format('HH:mm') }}</td>
              <td class="px-6 py-4">{{ moment(time.end_time).utc(false).format('HH:mm') }}</td>
              <td class="px-6 py-4">{{ time.total_hours }}</td>
              <td class="px-6 py-4">{{ time.total_break }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
