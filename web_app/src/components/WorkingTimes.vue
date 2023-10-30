<script setup lang="ts">
    import { ref } from 'vue'
    import moment from 'moment'
    import axios from 'axios'
    import { useRouter, useRoute } from 'vue-router'
    import { Bar } from 'vue-chartjs'
    import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

    const route = useRoute();
    const params = route.params;
    // const userId = params.userId;

    // debug
    var userId = 1;

    function getWorkingTimes(start: string = '2023-01-01T00:00:00Z', end: string = moment().format('YYYY-MM-DD') + "00:00:00Z") {
      const requestUrl = `http://localhost:4000/api/workingtimes/${userId}?start=${start}&end_time=${end}`;

      axios.get(requestUrl)
        .then((response) => {
          const data = response.data;
          console.log(data);
          // Faites quelque chose avec les données reçues

        }).catch((error) => {
          console.error('Erreur API', error);
        });
    }

    const dateValue = ref([]);

    function dDate(date: object) {
      return date > new Date() 
    }

    const formatter = ref({
      // date: 'DD-MM-YYYY',
      date: 'YYYY-MM-DD',
      month: 'MMM',
    })

    const handleDate = (modelData: Array<string>) => {
      var start = modelData[0] + "%";
      var end = modelData[1] + "%";

      getWorkingTimes(start, end);

    }

</script>

<script lang="ts">
  // todo data depuis api
  const workingTimes = [
      { start: '2023-10-10 08:44', end: '2023-10-10 18:24' }, 
      { start: '2023-10-11 08:45', end: '2023-10-10 16:34' }, 
      { start: '2023-10-12 08:50', end: '2023-10-10 15:54' }, 
      { start: '2023-10-13 08:51', end: '2023-10-10 16:44' }, 
  
  ];

  const workingTimesRef = ref(workingTimes);

  ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

  export default {
    name: 'BarChart',
    components: { Bar },
    data() {
      return {
        workingTimes: [
          { start: '2023-10-10 08:44', end: '2023-10-10 18:24' },
          { start: '2023-10-11 08:45', end: '2023-10-11 16:34' },
          { start: '2023-10-12 08:50', end: '2023-10-12 15:54' },
          { start: '2023-10-13 08:51', end: '2023-10-13 16:44' },
        ],
        chartData: {
          labels: [],
          datasets: [
            {
              label: 'Heures de travail',
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              borderColor: 'rgba(75, 192, 192, 1)',
              borderWidth: 1,
              data: [],
            },
          ],
        },
        chartOptions: {
          responsive: true,
        },
      };
    },
    methods: {
      calculateDuration(startTime: string, endTime: string) {
        const startMoment = moment(startTime, 'YYYY-MM-DD HH:mm');
        const endMoment = moment(endTime, 'YYYY-MM-DD HH:mm');
        const duration = moment.duration(endMoment.diff(startMoment));
        return duration.asHours();
      },
      updateChartData() {
        this.chartData.labels = this.workingTimes.map(item => moment(item.start).format('YYYY-MM-DD'));
        this.chartData.datasets[0].data = this.workingTimes.map(item => {
          return this.calculateDuration(item.start, item.end);
        });
      },
    },
    created() {
      this.updateChartData();
    },
  };
</script>

<template>
  <div>

    <div class="grid grid-rows-2">
        <vue-tailwind-datepicker 
          as-single use-range
          i18n="fr" 
          v-model="dateValue" 
          :disable-date="dDate"
          :formatter="formatter"
          @update:model-value="handleDate"
        />

        <div>
            <Bar id="my-chart-id" :options="chartOptions" :data="chartData"/>
    
        </div>
        
            <div class="relative overflow-x-auto">
                <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
                    <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
                        <tr>
                            <th scope="col" class="px-6 py-3">
                                Date
                            </th>
                            <th scope="col" class="px-6 py-3">
                                Start Time
                            </th>
                            <th scope="col" class="px-6 py-3">
                                End Time
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700" v-for="(time, index) in workingTimes" :key="index">
                            <td class="px-6 py-4">{{ moment(time.start).format('YYYY-MM-DD') }}</td>
                            <td class="px-6 py-4">{{ moment(time.start).format('HH:MM') }}</td>
                            <td class="px-6 py-4">{{ moment(time.end).format('HH:MM') }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
        </div>

    </div> 
    
</template>

<style scoped>

</style>
