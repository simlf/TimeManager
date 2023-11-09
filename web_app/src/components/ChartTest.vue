<script setup lang="ts">
import { ref, defineProps, onMounted, watchEffect } from 'vue';
import { Bar } from 'vue-chartjs';

const { chartDataProp, labelsProp } = defineProps(['chartDataProp', 'labelsProp']);
const chartData = ref({
  labels: labelsProp || ['t1', 't2', 't3', 't4'],
  datasets: [
    {
      label: 'Working Hours',
      backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
      data: [10, 20, 30, 5], // Données de test par défaut
      stack: "Stack 0",
    }
  ]
});

onMounted(() => {
  console.log('ChartDataProp received:', chartDataProp);
  console.log('LabelsProp received:', labelsProp);

  // Mise à jour du graphique une seule fois lors de l'initialisation
  updateChartData();
});

watchEffect(() => {
  // Mettez à jour la référence chartData lorsque chartDataProp change
  updateChartData();
});

function updateChartData() {
  if (chartDataProp && chartDataProp.datasets && chartDataProp.datasets.length > 0 && chartDataProp.datasets[0].data) {
    chartData.value.labels = labelsProp || ['t1', 't2', 't3', 't4'];
    chartData.value.datasets[0].data = chartDataProp.datasets[0].data.slice();
  }
}
</script>

<!-- Le reste du code reste inchangé -->


<script lang="ts">
export default {
  name: 'ChartComponent',
  components: { Bar },
  setup() {
    return {
      chartData,
    };
  },
  computed: {
    chartOptions() {
      return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
          }
        }
      };
    }
  },
  methods: {
    updateChartData() {
      // Mettez à jour les données du graphique ici
    }
  }
};
</script>

<template>
  <div>
    <div v-if="chartDataProp && labelsProp">
      {{ chartDataProp }}
      {{ labelsProp }}
      <Bar :data="chartData" :options="chartOptions" />
    </div>
  </div>
</template>

<style scoped></style>
