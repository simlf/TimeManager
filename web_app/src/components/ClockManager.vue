<template>
  <div>
    <h1>{{ startDateTime }}</h1>
    <h1>{{ clockIn }}</h1>
  </div>

  <div>
    <button @click="refresh">Refresh</button>
    <br />
    <button @click="clock">Clock</button>
  </div>
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
const instance = axios.create()
instance.interceptors.request.use((config) => {
  console.log('Corps de la requête :', config.data)
  return config
})

const clock = () => {
  clockIn.value = !clockIn.value
  updateClock()
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

const refresh = () => {
  console.log('Try to get clock with usr_id : ' + user_id)
  instance
    .get(API_URL_clock)
    .then((response: AxiosResponse) => {
      getClockSuccess(response.data.data)
    })
    .catch(requestFailed)
}

const updateSuccess = () => {
  console.log('update - success')
  refresh()
}

const updateClock = () => {
  console.log('Try to update clock with usr_id : ' + user_id)
  startDateTime.value = ''
  const currentDate = new Date().toISOString().split('.')[0]
  const clock = {
    status: clockIn.value,
    time: currentDate,
    user_id: 1
  }
  console.log(clock)
  instance.put(API_URL_clock, { clock }, { headers }).then(updateSuccess).catch(requestFailed)
}

refresh()
</script>

<style scoped></style>
