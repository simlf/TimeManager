<script setup lang="ts">
  import { ref, onMounted } from 'vue'
  import { useRoute } from 'vue-router'
  import { Bar } from 'vue-chartjs'
  import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
  import moment from 'moment'
  import axios from 'axios'

  ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

  const route = useRoute();
  const params = route.params;
  // const userId = params.userId;
</script>

<script lang="ts">
  // debug
  var userId = 1;
  let workingTimesRef = ref();

  const dateValue = ref([]);

  function dDate(date: object) {
    return date > new Date() 
  }

  const formatter = ref({
    // date: 'DD-MM-YYYY',
    date: 'YYYY-MM-DD',
    month: 'MMM',
  })

  export default {
    name: 'BarChart',
    components: { Bar },
    data() {
      return {
        chartData: {
          labels: ["t1", "t2"],
          datasets: [
            {
              label: 'Heures de travail',
              backgroundColor: 'rgba(75, 192, 192, 0.2)',
              borderColor: 'rgba(75, 192, 192, 1)',
              borderWidth: 1,
              // data: []
              data: [10, 20, 30], // Données de test par défaut
            },
          ],
        },
      };
    },
    computed: {
      chartOptions() {
        return {
          responsive: true,
          maintainAspectRatio: false,
        };
      },
      // chartData() {
      //   return {
      //     labels: ["t1", "t2"],
      //     datasets: [
      //       {
      //         label: 'Heures de travail',
      //         backgroundColor: 'rgba(75, 192, 192, 0.2)',
      //         borderColor: 'rgba(75, 192, 192, 1)',
      //         borderWidth: 1,
      //         data: [14, 50]
      //       }
      //     ]
      //   }      
      // }      
    },
    methods: {
      async getWorkingTimes(start: string = '2023-01-01', end: string = moment().format('YYYY-MM-DD')) {
        start += "2000:00:00";
        end += "2000:00:00";
        const requestUrl = `http://localhost:4000/api/workingtimes/${userId}?start=${start}&end_time=${end}`;

        console.log(requestUrl);

        try {
          const response = await axios.get(requestUrl);
          const data = response.data;
          workingTimesRef.value = data.data;

          // Mise à jour du graphique
          this.updateChartData();
          
        } catch (error) {
          console.error('Erreur API', error);
        }
      },
      calculateDuration(startTime: string, endTime: string) {
        const startMoment = moment(startTime, 'YYYY-MM-DD HH:mm');
        const endMoment = moment(endTime, 'YYYY-MM-DD HH:mm');
        const duration = moment.duration(endMoment.diff(startMoment));
        return duration.asHours();
      },
      updateChartData() {
        this.chartData.labels = workingTimesRef.value.map(item =>
          moment(item.start).format('YYYY-MM-DD')
        );
        this.chartData.datasets[0].data = workingTimesRef.value.map(item => 
          this.calculateDuration(item.start, item.end_time)
        );
        
        this.triggerChartDataUpdate()

      },
      handleDateClick(modelData: Array<string>) {
        const start = modelData[0] + "%";
        const end = modelData[1] + "%";

        this.getWorkingTimes(start, end);
      },
      triggerChartDataUpdate(){
        this.chartData = {...this.chartData, datasets: [...this.chartData.datasets], labels: [...this.chartData.labels]}
      }

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
          @update:model-value="handleDateClick"
        />

        <div>
            <Bar id="my-chart-id" :options="chartOptions" :data="chartData" ref="bar"/>
    
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
                        <tr class="bg-white border-b dark:bg-gray-800 dark:border-gray-700" v-for="(time, index) in workingTimesRef" :key="index">
                          <td class="px-6 py-4">{{ moment(time.start).utc(false).format('YYYY-MM-DD') }}</td>
                          <td class="px-6 py-4">{{ moment(time.start).utc(false).format('HH:mm') }}</td>
                          <td class="px-6 py-4">{{ moment(time.end_time).utc(false).format('HH:mm') }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
        </div>

    </div> 
    
</template>

<style scoped>

</style>
