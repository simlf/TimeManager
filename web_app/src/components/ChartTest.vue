<script setup lang="ts">
import { ref, defineProps, onMounted, watchEffect, getCurrentInstance, watch } from 'vue';
import { Bar } from 'vue-chartjs';

const { chartDataProp, labelsProp } = defineProps(['chartDataProp', 'labelsProp']);
const chartData = ref({
  labels: labelsProp || [],
  datasets: chartDataProp || [
    {
      label: 'Working Hours',
      backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
      data: [], // Données de test par défaut
      stack: 'Stack 0',
    },
  ],
});
const ctx = getCurrentInstance();

const updateChartData = () => {
  // Mettre à jour les données du graphique ici
  chartData.value.labels = labelsProp || [];
  chartData.value.datasets = chartDataProp;

};

onMounted(() => {
  // Écouter l'événement "updateChartDataEvent" émis par le composant parent
  ctx.emit('updateChartDataEvent', () => {
    updateChartData();
  });

  // Utiliser watch pour détecter les changements dans les props
  watch([() => chartDataProp, () => labelsProp], () => {
    updateChartData();
  });
});

watchEffect(() => {
  // Mettre à jour le graphique lorsque les props changent
  updateChartData();
});



</script>

<script lang="ts">
export default {
  name: 'chartTestComponent',
  components: { Bar },
  setup() {
    return {
      chartData,
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: true,
          },
        },
      },
    };
  },
}
</script>

<template>
  <div>
    <div v-if="chartDataProp && labelsProp">
      {{ chartDataProp }}
      {{ labelsProp }}
      <Bar :data="chartData" :options="chartOptions" ref="chartTestComponent"/>
    </div>
  </div>
</template>

<style scoped></style>
