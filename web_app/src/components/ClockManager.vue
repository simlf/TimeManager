<template>
  <div v-if="loading">
    <p>Loading...</p>
  </div>
  <div v-else>
    <div>
      <h1>{{ textToDisplay }}</h1>
    </div>
    <div class="button-container">
      <button
        v-if="clockIn == true || wasInBreakTime == true"
        @click="breakTime"
        class="breakTime-button"
      >
        {{ wasInBreakTime ? 'Back to work' : 'Break Time' }}
      </button>
      <button v-if="!clockIn && !wasInBreakTime" @click="startClock" class="clock-button">
        Start
      </button>
      <button v-else @click="stopClock" class="clock-button">Stop</button>
    </div>
  </div>
  <!-- <button @click="refresh" class="breakTime-button">Refresh</button> -->
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import type { AxiosInstance, AxiosResponse } from 'axios'

const user_id = 1
const API_URL_clock = `http://localhost:4000/api/clocks/${user_id}`
const API_URL_workTime = `http://localhost:4000/api/times/thisDay/${user_id}`
const API_URL_workingtimes_by_user = `http://localhost:4000/api/workingtimes/${user_id}`
const API_URL_update_workingtime = `http://localhost:4000/api/workingtimes/`
const API_URL_last_workingtimes = `http://localhost:4000/api/workingtimes/last/${user_id}`

const headers = { 'Content-Type': 'application/json' }

const route = useRoute()
const router = useRouter()

const clockIn = ref(false)
const wasInBreakTime = ref(false)
const loading = ref(true)
const startDateTime = ref('')
const textToDisplay = ref('Get information ...')
const welcomeMessage = 'Don’t forget to clock in at the start of your shift !'

const timeWorkedInDay = ref({
  hours: 0,
  minutes: 0,
  seconds: 0
})

const lastWorkingtime = ref({
  id: 0,
  start_time: '',
  end_time: '',
  is_pause: false
})
const instance: AxiosInstance = axios.create()

instance.interceptors.request.use((config) => {
  console.log('Request body:', config.data)
  return config
})

const getClockSuccess = (data: { time: string; status: boolean }) => {
  console.log('Get Clock - success')
  console.log(`New clock state: time = ${data.time} & status = ${data.status}`)
  clockIn.value = data.status
}

const getWorkingtimeSuccess = (data: {
  start_time: string
  end_time: string
  is_pause: boolean
  id: number
}) => {
  console.log('Get last Workingtime - success')
  console.log(
    `New last workingtime : start_time = ${data.start_time} & end_time = ${data.end_time} & is_pause = ${data.is_pause}`
  )
  lastWorkingtime.value.id = data.id
  lastWorkingtime.value.end_time = data.end_time
  lastWorkingtime.value.start_time = data.start_time
  lastWorkingtime.value.is_pause = data.is_pause
}
const startClock = () => {
  newWorkingtime(true)
  toggleClock()
}

const stopClock = () => {
  if (clockIn) {
    
  } else {
  }
  if (wasInBreakTime.value) {
    wasInBreakTime.value = false
  } else {
    toggleClock()
  }
}

const toggleClock = () => {
  clockIn.value = !clockIn.value
  startDateTime.value = new Date().toISOString().split('.')[0]
  updateClock()
}

const breakTime = () => {
  toggleClock()
  if (wasInBreakTime.value) {
    newWorkingtime(true)
  } else {
    closeWorkingtime()
  }
  wasInBreakTime.value = !wasInBreakTime.value
}

const updateClock = async () => {
  loading.value = true
  console.log('Trying to update clock with user_id: ' + user_id)
  const clock = {
    status: clockIn.value,
    time: startDateTime.value,
    user_id: user_id
  }
  try {
    await instance.put(API_URL_clock, { clock }, { headers })
    console.log('Update clock - success')
  } catch (error: any) {
    console.log('Update clock - failed')
    requestFailed(error)
  } finally {
      loading.value = false
  }
}

const newWorkingtime = async (is_pause: boolean) => {
  console.log('Trying to create workingtime with user_id: ' + user_id)
  const workingtimes = {
    start_time: startDateTime.value,
    is_pause: is_pause
  }

  try {
    await instance.post(API_URL_workingtimes_by_user, { workingtimes }, { headers })
    console.log('Create workingtime - success')
  } catch (error: any) {
    console.log('Create workingtime - failed')
    requestFailed(error)
  }
}
const closeWorkingtime = async () => {
  console.log('Trying to close workingtime with user_id: ' + user_id)

  try {
    const currentDate = new Date().toISOString().split('.')[0]
    const workingtimes = {
      end_time: currentDate,
      is_pause: false
    }
    console.log('Trying to update workingtime with id: ' + lastWorkingtime.value.id)
    try {
      await instance.put(
        API_URL_update_workingtime + lastWorkingtime.value.id,
        { workingtimes },
        { headers }
      )
      console.log('Update workingtime - success')
    } catch (error: any) {
      console.log('Update workingtime - failed')
      requestFailed(error)
    }
  } catch (error: any) {
    requestFailed(error)
    console.log('Close workingtime - failed')
  }
}

const calculateTimeWorked = () => {
  const currentTime = new Date()
  const startTime = new Date(startDateTime.value)

  const differenceInMilliseconds = currentTime.getTime() - startTime.getTime()

  let hours = Math.floor(differenceInMilliseconds / (1000 * 60 * 60))
  let minutes = Math.floor((differenceInMilliseconds % (1000 * 60 * 60)) / (1000 * 60))
  let seconds = Math.floor((differenceInMilliseconds % (1000 * 60)) / 1000)

  hours += timeWorkedInDay.value.hours
  minutes += timeWorkedInDay.value.minutes
  seconds += timeWorkedInDay.value.seconds

  if (seconds >= 60) {
    minutes += Math.floor(seconds / 60)
    seconds = seconds % 60
  }

  if (minutes >= 60) {
    hours += Math.floor(minutes / 60)
    minutes = minutes % 60
  }

  return {
    hours,
    minutes,
    seconds
  }
}

const updateDisplayMessage = (text: string) => {
  textToDisplay.value = text
}

const getWorkTimeSuccess = (data: { hours: number; minutes: number; seconds: number }) => {
  console.log('Get Work Time - success')
  timeWorkedInDay.value.hours = data.hours
  timeWorkedInDay.value.minutes = data.minutes
  timeWorkedInDay.value.seconds = data.seconds
  console.log('data.hours : ' + data.hours)
  console.log('data.minutes : ' + data.minutes)
  console.log('data.seconds : ' + data.seconds)
}

const requestFailed = (error: Error) => {
  console.log(error)
}

// Actualisation périodique de l'affichage du temps travaillé
setInterval(() => {
  if (!wasInBreakTime.value) {
    const { hours, minutes, seconds } = calculateTimeWorked()
    updateDisplayMessage(
      `Time worked: ${String(hours).padStart(2, '0')} h ${String(minutes).padStart(
        2,
        '0'
      )} m ${String(seconds).padStart(2, '0')} s`
    )
  }
})

const initData = async () => {
  loading.value = true
  try {
    const [clockResponse, workingtimeResponse, workTimeResponse] = await Promise.all([
      instance.get(API_URL_clock),
      instance.get(API_URL_last_workingtimes),
      instance.get(API_URL_workTime)
    ])

    getClockSuccess(clockResponse.data.data)
    getWorkingtimeSuccess(workingtimeResponse.data.data)
    getWorkTimeSuccess(workTimeResponse.data.data)
    if (lastWorkingtime.value.end_time != '') {
      //Entrain de travailler
      wasInBreakTime.value = false
    } else if (lastWorkingtime.value.is_pause) {
      //Retour de pause
      wasInBreakTime.value = true
    } else if (!lastWorkingtime.value.is_pause) {
      //Debut de journée
      updateDisplayMessage(welcomeMessage)
      wasInBreakTime.value = false
    } else {
      console.log('Warning : missing state')
    }
  } catch (error: any) {
    console.log('Error : Failed on Init')
    requestFailed(error)
  } finally {
    loading.value = false
  }
}

initData()
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
