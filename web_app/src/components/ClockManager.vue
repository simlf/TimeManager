<template>
  <div v-if="loading">
    <p>Loading...</p>
  </div>
  <div v-else class="mx-auto max-w-7xl px-6 py-24 sm:py-32 lg:px-8">
    <div>
      <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">{{ textToDisplay }}</h2>
    </div>
<!--    <div class="button-container">-->
    <div class="mt-10 flex items-center gap-x-6">
      <button
        v-if="clockIn == true || wasInBreakTime == true"
        @click="breakTime"
        class="rounded-md bg-white border-amber-950 border-2 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-black shadow-sm hover:bg-indigo-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black"
      >
<!--        class="breakTime-button"-->
        {{ wasInBreakTime ? 'Back to work' : 'Break Time' }}
      </button>
      <button v-if="!clockIn && !wasInBreakTime" @click="startClock" class="rounded-md bg-indigo-600 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
        Start
      </button>
<!--              class="clock-button">-->
      <button v-else @click="stopClock" class="rounded-md bg-indigo-600 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Stop</button>
<!--              class="clock-button"-->
    </div>
  </div>
  <!-- <button @click="refresh" class="breakTime-button">Refresh</button> -->
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

import type { AxiosResponse } from 'axios'
const headers = { 'Content-Type': 'application/json' }
const route = useRoute()
const router = useRouter()
const user_id = 1
const API_URL_clock = `http://localhost:4000/api/clocks/${user_id}`
const startDateTime = ref('')
const clockIn = ref(false)
const wasInBreakTime = ref(false) //Recupérer le dernier working time et voir si il est considéré comme étant endOfDay == false
const loading = ref(true)

const textToDisplay = ref('Get information ...')
const instance = axios.create()
instance.interceptors.request.use((config) => {
  console.log('Corps de la requête :', config.data)
  return config
})

const welcomeMessage = 'Don’t forget to clock in at the start of your shift !'

const startClock = () => {
  clock()
}

const stopClock = () => {
  if (wasInBreakTime.value) {
    wasInBreakTime.value = false
  } else {
    clock()
  }
}
// Fonction pour calculer le temps travaillé
const calculateTimeWorked = () => {
  const currentTime = new Date()
  const startTime = new Date(startDateTime.value)

  const differenceInMilliseconds = currentTime.getTime() - startTime.getTime()

  const hours = Math.floor(differenceInMilliseconds / (1000 * 60 * 60))
  const minutes = Math.floor((differenceInMilliseconds % (1000 * 60 * 60)) / (1000 * 60))
  const seconds = Math.floor((differenceInMilliseconds % (1000 * 60)) / 1000)

  return {
    hours,
    minutes,
    seconds
  }
}

// Actualisation périodique de l'affichage du temps travaillé
setInterval(() => {
  if (clockIn.value && wasInBreakTime.value == false) {
    const { hours, minutes, seconds } = calculateTimeWorked()
    updateDisplayMessage(
      // `Time worked: ${String(hours).padStart(2, '0')} h ${String(minutes).padStart(
      `${String(hours).padStart(2, '0')} h ${String(minutes).padStart(
        2,
        '0'
      )} m ${String(seconds).padStart(2, '0')} s`
    )
  }
}, 1000)

const updateDisplayMessage = (text: string) => {
  textToDisplay.value = text
}
const clock = () => {
  loading.value = true
  clockIn.value = !clockIn.value
  startDateTime.value = new Date().toISOString().split('.')[0]
  updateClock()
}
const breakTime = () => {
  clock()
  wasInBreakTime.value = !wasInBreakTime.value
}
const getClockSuccess = (data: { time: string; status: boolean }) => {
  console.log('Get - success')
  startDateTime.value = data.time
  clockIn.value = data.status
  console.log(`New clock state: time = ${startDateTime.value} & status = ${clockIn.value}`)
}

const requestFailed = (error: Error) => {
  console.log(error)
}

const refresh = async () => {
  loading.value = true
  console.log('Try to get clock with usr_id : ' + user_id)
  await instance
    .get(API_URL_clock)
    .then((response: AxiosResponse) => {
      getClockSuccess(response.data.data)
    })
    .catch(requestFailed)
  if (clockIn.value == false && wasInBreakTime.value == false) {
    updateDisplayMessage(welcomeMessage)
  }
  loading.value = false
}

const updateSuccess = () => {
  console.log('update - success')
  refresh()
}

const updateClock = () => {
  console.log('Try to update clock with usr_id : ' + user_id)
  const currentDate = new Date().toISOString().split('.')[0]
  const clock = {
    status: clockIn.value,
    time: currentDate,
    user_id: user_id
  }
  instance.put(API_URL_clock, { clock }, { headers }).then(updateSuccess).catch(requestFailed)
}

refresh()
</script>

<style scoped>
.clock-button {
  background-color: black;
  border: 2px solid black;
  color: white;
  padding: 10px 20px;
  margin: 1rem;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
}

.clock-button:hover {
  background-color: #505050;
}

.breakTime-button {
  background-color: white;
  border: 2px solid black;
  color: black;
  padding: 10px 20px;
  margin: 1rem;
  border-radius: 5px;
  font-size: 16px;
  cursor: pointer;
}
.breakTime:hover {
  background-color: #8c8a8a;
}

.button-container {
  display: flex;
  align-items: center; /* Centre verticalement les boutons */
}
</style>
