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
const urlGetClockByUser = `http://localhost:4000/api/clocks/users/${user_id}`
let startDateTime = null
let clockIn = false

const clock = () => {
  console.log('Status: ' + clockIn)
  clockIn = !clockIn
  console.log('Status: ' + clockIn)
}
const findClock = (response) => {
  console.log('Find Clock: ' + response.data)
  clockIn = response.data.data.status
}

const requestFailed = (error) => {
  console.log(error)
}

const makeAxiosRequestAsync = async (requestUrl, acceptCallback, rejectCallback) => {
  axios.get(requestUrl).then(acceptCallback, rejectCallback)
}

const refresh = () => {
  console.log(urlGetClockByUser)
  makeAxiosRequestAsync(urlGetClockByUser, findClock, requestFailed)
}

refresh()
clock()
</script>

<style scoped></style>
