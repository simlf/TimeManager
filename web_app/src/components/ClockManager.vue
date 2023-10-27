<template>
  <div>
    <h1>{{ startDateTime }}</h1>
    <h1>{{ clockIn }}</h1>
  </div>

  <div>
    <button @click="refresh()">Refresh</button>
    <br />
    <button @click="clock()">Clock</button>
  </div>
</template>

<script setup lang="ts">
// ClockManager
// – used to declare hours worked ;
// – connected to the /clock/:username route ;
// – it must have:
// * startDateTime data (is worth null if no work period is in progress) ;
// * clockIn (a boolean that is true if a work period is in progress) ;
// * refresh() and clock() methods (to pass from active to inactive and vice versa).
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'

const route = useRoute()
const router = useRouter()
const user_id = 1
const API_URL_clock = `http://localhost:4000/api/clocks/users/${user_id}`

const startDateTime = ref(null)
const clockIn = ref(false)
const clock = () => {
  console.log('Status: ' + clockIn.value)
  clockIn.value = !clockIn.value
  console.log('Status: ' + clockIn.value)
}
const findClock = (response) => {
  console.log('Find Clock: ' + response.data)
  startDateTime.value = response.data.data.time
  console.log('startDateTime: ' + startDateTime.value)

  clockIn.value = response.data.data.status
}

const requestFailed = (error) => {
  console.log(error)
}
const refresh = () => {
    axios.get(API_URL_clock).then(findClock, requestFailed);
}
const updateClock =() => {
    let clockUpdate = {
        
    }
    axios.put(API_URL_clock).then(findClock, requestFailed);

}

refresh()
</script>

<style scoped></style>
