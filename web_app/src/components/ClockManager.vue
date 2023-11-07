<template>
  <div class="mx-auto max-w-7xl px-6 py-24 sm:py-32 lg:px-8">
    <div v-if="loading">
      <orbit-spinner :animation-duration="1200" :size="55" color="#3F51B5" />
    </div>
    <div v-else>
      <div>
        <h2 class="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
          {{ textToDisplay }}
        </h2>
      </div>
      <div class="mt-10 flex items-center gap-x-6">
        <button
          :disabled="loading"
          v-if="clockIn == true || wasInBreakTime == true"
          @click="breakTime"
          class="rounded-md bg-white border-amber-950 border-2 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-black shadow-sm hover:bg-indigo-50 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black"
        >
          {{ wasInBreakTime ? 'Back to work' : 'Break Time' }}
        </button>
        <button
          :disabled="loading"
          v-if="!clockIn && !wasInBreakTime"
          @click="startWork"
          class="rounded-md bg-indigo-600 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Start
        </button>
        <button
          :disabled="loading"
          v-else
          @click="stopWork"
          class="rounded-md bg-indigo-600 min-w-[200px] w-full max-w-[250px] py-4 text-base font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Stop
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import axios from 'axios'
import { OrbitSpinner } from 'epic-spinners'
import type { AxiosInstance, AxiosResponse } from 'axios'
import { useAuthStore } from '@/stores/auth.store'

const authStore = useAuthStore()

const user_id = authStore.id
const API_URL_clock = `http://localhost:4000/api/clocks/${user_id}`
const API_URL_workTime = `http://localhost:4000/api/times/thisDay/${user_id}`
const API_URL_workingtimes_by_user = `http://localhost:4000/api/workingtimes/${user_id}`
const API_URL_update_workingtime = `http://localhost:4000/api/workingtimes/`
const API_URL_last_workingtimes = `http://localhost:4000/api/workingtimes/last/${user_id}`

const headers = { 'Content-Type': 'application/json' }

const clockIn = ref(false)
const wasInBreakTime = ref(false)
const loading = ref(true)
const clockTime = ref('')
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
  is_pause: false,
  type: ''
})
const instance: AxiosInstance = axios.create()

instance.interceptors.request.use((config) => {
  console.log('Request body:', config.data)
  return config
})

const getCurrentDateWithoutTimeZone = () => {
  return new Date().toISOString().slice(0, -1)
}

const getClockSuccess = (data: { time: string; status: boolean }) => {
  console.log('Get Clock - success')
  console.log(`New clock state: time = ${data.time} & status = ${data.status}`)
  clockIn.value = data.status
  clockTime.value = data.time
}

const getWorkingtimeSuccess = (data: {
  start_time: string
  end_time: string
  is_pause: boolean
  id: number
  type: string
}) => {
  console.log('Get last Workingtime - success')
  console.log(
    `New last workingtime : start_time = ${data.start_time} & end_time = ${data.end_time} & is_pause = ${data.is_pause} & type = ${data.type}`
  )
  lastWorkingtime.value.id = data.id
  lastWorkingtime.value.end_time = data.end_time
  lastWorkingtime.value.start_time = data.start_time
  lastWorkingtime.value.is_pause = data.is_pause
  lastWorkingtime.value.type = data.type
}
const startWork = async () => {
  loading.value = true
  await toggleClock()
  newWorkingtime('start_work', false)
  loading.value = false
}

const stopWork = async () => {
  loading.value = true
  closeWorkingtime(true)
  if (wasInBreakTime.value) {
    wasInBreakTime.value = false
    clockTime.value = getCurrentDateWithoutTimeZone()
  } else {
    await toggleClock()
  }
  await initData()
  loading.value = false
}

const toggleClock = async () => {
  clockIn.value = !clockIn.value
  clockTime.value = getCurrentDateWithoutTimeZone()
  await updateClock()
}

const breakTime = async () => {
  loading.value = true
  toggleClock()
  if (wasInBreakTime.value) {
    await closeWorkingtime(false) //Fermeture de la periode de pause
    await newWorkingtime('basic_work', false) //Nouvelle periode de travail
  } else {
    await closeWorkingtime(false) //Fermeture de la periode de travail
    await newWorkingtime('pause', true) //Nouvelle periode de pause
  }

  wasInBreakTime.value = !wasInBreakTime.value
  await getWorkTime()
  loading.value = false
}

const getWorkTime = async () => {
  try {
    const workTimeResponse = await instance.get(API_URL_workTime)
    getWorkTimeSuccess(workTimeResponse.data.data)
  } catch (error: any) {
    console.log('Update clock - failed')
    requestFailed(error)
  }
}
const updateClock = async () => {
  console.log('Trying to update clock with user_id: ' + user_id)
  const clock = {
    status: clockIn.value,
    time: clockTime.value,
    user_id: user_id
  }
  try {
    await instance.put(API_URL_clock, { clock }, { headers })
    console.log('Update clock - success')
  } catch (error: any) {
    console.log('Update clock - failed')
    requestFailed(error)
  }
}

const newWorkingtime = async (type: string, is_pause: boolean) => {
  console.log('Trying to create workingtime with user_id: ' + user_id)

  const workingtimes = {
    start_time: clockTime.value,
    type: type,
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

const newWorkingtimeToEndWorkday = async () => {
  const workingtimes = {
    start_time: clockTime.value,
    end_time: clockTime.value,
    type: 'end_work',
    is_pause: false
  }

  try {
    await instance.post(API_URL_workingtimes_by_user, { workingtimes }, { headers })
    console.log('Create workingtime - success')
  } catch (error: any) {
    console.log('Create workingtime - failed')
    requestFailed(error)
  }
}

const checkIfLastWorkingtimeExist = async () => {
  let thereAreWorkingtime
  try {
    const workingtimeResponse = await instance.get(API_URL_last_workingtimes)
    getWorkingtimeSuccess(workingtimeResponse.data.data)
    console.log('Update workingtime - succed')
    thereAreWorkingtime = true
  } catch (error: any) {
    console.log('Update workingtime - failed')
    requestFailed(error)
    thereAreWorkingtime = false
  } finally {
    console.log('checkIfLastWorkingtimeExist : ' + thereAreWorkingtime)
    return thereAreWorkingtime
  }
}
const closeWorkingtime = async (stop_work: boolean) => {
  console.log('Trying to close workingtime with user_id: ' + user_id)
  try {
    if (!(await checkIfLastWorkingtimeExist())) {
      console.log('There are no workingtime actually')
      return
    }
    const workingtimes = {
      end_time: clockTime.value,
      type: lastWorkingtime.value.type != 'start_work' && stop_work ? 'end_work' : undefined
    }

    if (stop_work && lastWorkingtime.value.type === 'start_work') {
      newWorkingtimeToEndWorkday()
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
  const currentTime = new Date(getCurrentDateWithoutTimeZone())
  const startTime = new Date(clockTime.value)
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
  console.log(`Time worked today : ${data.hours}H ${data.minutes}min ${data.seconds}sec`)
}

const requestFailed = (error: Error) => {
  console.log(error)
}

// Actualisation périodique de l'affichage du temps travaillé
setInterval(() => {
  if (!wasInBreakTime.value && clockIn.value) {
    const { hours, minutes, seconds } = calculateTimeWorked()
    updateDisplayMessage(
      // `Time worked: ${String(hours).padStart(2, '0')} h ${String(minutes).padStart(
      `${String(hours).padStart(2, '0')} h ${String(minutes).padStart(2, '0')} m ${String(
        seconds
      ).padStart(2, '0')} s`
    )
  }
}, 1000)

const initData = async () => {
  loading.value = true
  try {
    const [clockResponse, workingtimeResponse] = await Promise.all([
      instance.get(API_URL_clock),
      instance.get(API_URL_last_workingtimes)
    ])
    getClockSuccess(clockResponse.data.data)
    if (workingtimeResponse.data.data != undefined) {
      //Il y a un workingtime
      getWorkingtimeSuccess(workingtimeResponse.data.data)
    }
    if (workingtimeResponse.data.data === undefined) {
      // Première période de travail
      updateDisplayMessage(welcomeMessage)
      console.log('Première période de travail')
    } else if (lastWorkingtime.value.end_time === '') {
      // En train de travailler
      console.log('En train de travailler')
      getWorkTime()
    } else if (lastWorkingtime.value.type === 'end_work') {
      // Début de journée car le workingtime précédent était celui de fin
      console.log('Début de journée')
      updateDisplayMessage(welcomeMessage)
    } else if (lastWorkingtime.value.is_pause) {
      if (lastWorkingtime.value.end_time !== '') {
        // Reprise du travail car le workingtime précédent est marqué comme étant une pause
        console.log('Reviens de pause')
      } else {
        // Encore en pause
        console.log('Encore en pause')
      }

      await getWorkTime()

      updateDisplayMessage(
        `Time worked: ${String(timeWorkedInDay.value.hours).padStart(2, '0')} h ${String(
          timeWorkedInDay.value.minutes
        ).padStart(2, '0')} m ${String(timeWorkedInDay.value.seconds).padStart(2, '0')} s`
      )
    } else {
      console.log('Avertissement : état manquant')
    }

    wasInBreakTime.value =
      lastWorkingtime.value.is_pause && lastWorkingtime.value.type != 'end_work'
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
