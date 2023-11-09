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

localStorage.clear()

const lastMonday = getLastMonday();
const start = ref(localStorage.getItem('start') || lastMonday)
const end = ref(localStorage.getItem('end') || moment().format('YYYY-MM-DD'))


const currentView = ref("Default View")
const buttonText = ref("Manager View")

export default {
  name: 'BarChart',
  components: { Bar, Doughnut },
  setup() {
    const route = useRoute();
    const userId = route.params.id;

    console.log(userId)


  },
  props: {
    dataParam: {
      type: Number, 
      required: true
    }
  },

  data() {
    return {
      chartDataDoughnut: {
        labels: ['Label 1', 'Label 2', 'Label 3', 'Label 4'],
        datasets: [
          {
            label: 'Doughnut Chart',
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            data: [25, 30, 15, 10]
          }
        ]
      },
      chartData: {
        labels: ['t1', 't2', 't3', 't4'],
        datasets: [
          {
            label: 'Working Hours',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 1,
            // data: []
            data: [10, 20, 30, 5] // Données de test par défaut
          }
        ]
      }
    }
  },
  computed: {
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: false
      }
    }
  },
  mounted() {
    console.log('La valeur de la prop dataParam est :', this.dataParam);
  },
  created() {
    this.getWorkingTimes();
  },
  methods: {
    async getWorkingTimes(
      // start: string = '2023-11-01%',
      // end: string = moment().format('YYYY-MM-DD') + "%"
    ) {
      console.log(this.dataParam)

      // localStorage.setItem('start', start.value);  
      // localStorage.setItem('end', end.value);

      start.value += '%2000:00:00'
      end.value += '%2023:59:59'
      const requestUrl = `http://localhost:4000/api/workingtimes/${this.dataParam}?start_time=${start.value}&end_time=${end.value}`

      console.log(requestUrl)

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
    mounted() {
      console.log('La valeur de la prop dataParam est :', this.dataParam);
    },
    calculateDuration(startTime: string, endTime: string) {
      const startMoment = moment(startTime, 'YYYY-MM-DD HH:mm')
      const endMoment = moment(endTime, 'YYYY-MM-DD HH:mm')
      const duration = moment.duration(endMoment.diff(startMoment))
      return duration.asHours()
    },
    updateChartData() {
      this.chartData.labels = workingTimesRef.value.map((item) =>
        moment(item.start_time).format('YYYY-MM-DD')
      )
      this.chartData.datasets[0].data = workingTimesRef.value.map((item) =>
        this.calculateDuration(item.start_time, item.end_time)
      )

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
    toggleView() {
      currentView.value = currentView.value === "Default View" ? "Manager View" : "Default View";
      buttonText.value = currentView.value === "Default View" ? "Manager View" : "Default View";

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

</script>

<template>

  <div class=" md:items-center md:justify-center">
    <div class="">
      <div class="mx-1 mt-2">
        <div>
          <Doughnut id="my-doughnut-chart-id" :data="chartDataDoughnut" :options="chartOptions" ref="doughnut" />
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
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>
