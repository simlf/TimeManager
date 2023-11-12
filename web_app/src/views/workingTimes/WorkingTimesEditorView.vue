<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'
import moment from 'moment'
import { PencilIcon } from '@heroicons/vue/20/solid'
import AlertBox from '@/components/utils/AlertBox.vue'
import { useAuthStore } from '@/stores/auth.store'

const authStore = useAuthStore()

const workingTimes = ref([])
const users = ref()

type User = {
  id: number
  email: string
  username: string
}

type WorkingTime = {
  id: number
  type: string
  start_time: string
  end_time: string
  is_pause: boolean
}

onMounted(async () => {
  users.value = await getUsers()
})

const selectedUserId = ref('')
const date = ref()
const noData = ref(true)
const successMessage = ref()
const errorMessage = ref()

const getUsers = async (): Promise<User[] | []> => {
  const url = 'http://localhost:4000/api/users'
  const users = await axios.get(url)
  return users.data.data
}

const getWorkingTimes = async (): Promise<WorkingTime[] | []> => {
	if (!selectedUserId.value || !date.value ) return;
  const workingTimes = await axios.get(`http://localhost:4000/api/workingtimes/${selectedUserId.value}?start_time=${date.value}%2000:00:00&end_time=${date.value}%2023:59:59`)
  	
	return workingTimes.data.data
}

function formatHoursMinutes(date) {
    return moment(date).utc(false).format('HH:mm')
}

const editingId = ref(null)
const editedTime = ref(null)

const toggleEdit = (id) => {
	successMessage.value = ""
	errorMessage.value = ""

  if (editingId.value === id) {
    // Si on clique à nouveau sur le bouton d'édition, on annule l'édition
    editingId.value = null
    editedTime.value = null
  } else {
    // Sinon, on active l'édition
    editingId.value = id
    // Vous pouvez initialiser editedTime avec la valeur actuelle si nécessaire
    // editedTime.value = moment(workingTimes.value.find(time => time.id === id).start_time).format('HH:mm')
  }
}

const dateValue = ref([moment().format('YYYY-MM-DD')]);

const formatter = ref({
  date: 'YYYY-MM-DD',
  month: 'MMM'
})

function dDate(selectedDate: object) {
  return selectedDate > new Date()
}

function compareHours(hour1, hour2) {
  const [h1, m1] = hour1.split(':').map(Number);
  const [h2, m2] = hour2.split(':').map(Number);

  if ((h1 > h2) || (h1 === h2 && m1 >= m2)) {
    return true;
  } else {
    return false;
  }
}

function handleInputChange(event, index) {
	const end_time = workingTimes.value[index].end_time 

	if ((index === 0 && compareHours(editedTime.value, formatHoursMinutes(end_time))) ||
		(index !== 0 && (compareHours(editedTime.value, formatHoursMinutes(end_time)) || 
		compareHours(formatHoursMinutes(workingTimes.value[index - 1].start_time), editedTime.value)))
	) {
		successMessage.value = "false"
		errorMessage.value = "start_time cannot be after end_time or before previous start_time"
		return;
	}

	errorMessage.value = ""

	let requestUrl = "http://localhost:4000/api/workingtimes/" + editingId.value
	let params = {
			workingtimes: {
				start_time: date.value + "T" + editedTime.value + ":00Z",
				end_time: end_time,
				is_pause: workingTimes.value[index].is_pause
			}
		};

		console.log(workingTimes.value)

	if (index === 0) {
		axios.put(requestUrl, params)
			.then(response => {
				console.log('Réponse:', response.data);
			})
			.catch(error => {
				console.error('Erreur de la requête PUT:', error);
			});

		workingTimes.value[0].start_time = date.value + "T" + editedTime.value + ":00Z"
		successMessage.value = editedTime.value

	} else {
		let params = {
			workingtimes: {
				start_time: date.value + "T" + editedTime.value + ":00Z",
				end_time: end_time,
				is_pause: workingTimes.value[index].is_pause
			}
		};
		
		axios.put(requestUrl, params)
			.then(response => {
				console.log('Réponse:', response.data);
				requestUrl = "http://localhost:4000/api/workingtimes/" + workingTimes.value[index-1].id
				params = {
					workingtimes: {
						start_time: moment(workingTimes.value[index-1].start_time).utc(false).format("YYYY-MM-DDThh:mm:ssZ"),
						end_time: moment(workingTimes.value[index-1].end_time).utc(false).format("YYYY-MM-DD") + "T" + editedTime.value + ":00Z",
						is_pause: workingTimes.value[index-1].is_pause
					}
				};
				
				axios.put(requestUrl, params)
					.then(response => {
						console.log('Réponse:', response.data);
					})
					.catch(error => {
						console.error('Erreur de la requête PUT:', error);
					});
					
			})
			.catch(error => {
				console.error('Erreur de la requête PUT:', error);
			});

			workingTimes.value[index].start_time = date.value + "T" + editedTime.value + ":00Z"
			workingTimes.value[index-1].end_time = moment(workingTimes.value[index-1].end_time).utc(false).format("YYYY-MM-DD") + "T" + editedTime.value + ":00Z"

			successMessage.value = editedTime.value	
	}
}

async function handleDateClick(modelData) {
	date.value = modelData[0]
	workingTimes.value = await getWorkingTimes()

	noData.value = !Boolean(workingTimes.value) || workingTimes.value.length === 0;
}

async function handleSelectionChange() {
	workingTimes.value = await getWorkingTimes()
	noData.value = !Boolean(workingTimes.value) || workingTimes.value.length === 0;
}

const tabs = [
  { name: 'Default View', href: '/workingTimes/', current: false, hidden: false },
  { name: 'Manager View', href: '/workingTimesManager/', current: false, hidden: authStore.isSuperManager },
  { name: 'SuperManager View', href: '/workingTimesSuperManager/', current: false, hidden: !authStore.isSuperManager },
  { name: 'Editor', href: '/workingTimesEditor/', current: true, hidden: !authStore.isSuperManager },
]
</script>

<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">

		<!-- Manager navbar -->
    
    <div class="relative border-b border-gray-200 pb-5 sm:pb-0">
      <div class="md:flex md:items-center md:justify-between">
        <!-- <h3 class="text-base font-semibold leading-6 text-gray-900">User View</h3> -->
      </div>
      <div class="mt-4">
        <div class="sm:hidden">
          <label for="current-tab" class="sr-only">Select a tab</label>
          <select id="current-tab" name="current-tab" class="block w-full rounded-md border-0 py-1.5 pl-3 pr-10 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-inset focus:ring-indigo-600">
            <option v-for="tab in tabs" :key="tab.name" :selected="tab.current" :v="tab.hidden">{{ tab.name }}</option>
          </select>
        </div>
        <div class="hidden sm:block">
          <nav class="-mb-px flex space-x-8">
            <a v-for="tab in tabs" :key="tab.name" :href="tab.href" :hidden="tab.hidden" :class="[tab.current ? 'border-indigo-500 text-indigo-600' : 'border-transparent text-gray-500 hover:border-gray-300 hover:text-gray-700', 'whitespace-nowrap border-b-2 px-1 pb-4 text-sm font-medium']" :aria-current="tab.current ? 'page' : undefined">{{ tab.name }}</a>
          </nav>
        </div>
      </div>
    </div>

    <!-- <div>
        <input type="time" id="first_name" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="John" required>
    </div> -->
    <!-- Table group users -->
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <!-- <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Working Times Editor
        </h2> -->
        <p class="mt-2 text-sm text-gray-700">
          <!-- Selected Date : {{ workingTimes[0].start_time }} -->
        </p>
      </div>
    </div>

		<AlertBox v-if="successMessage" type="success" :message="'Edited time succesfully ' + '(' + successMessage + ')'" />
		<AlertBox v-if="errorMessage" type="error" :message="'Error editing time : ' + errorMessage" />

		<div class="lg:w-96 mx-auto mt-2">
			<vue-tailwind-datepicker
				as-single
				i18n="fr"
				v-model="dateValue"
				:disable-date="dDate"
				:formatter="formatter"
				@update:model-value="handleDateClick"
			/>
		</div>

		<div class="lg:w-96 mx-auto mt-2">
			<label for="users" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Select user</label>
			<select v-model="selectedUserId" id="users" @change="handleSelectionChange" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500">
				<option value="" selected disabled>Select user</option>
				<option v-for="user in users" :key="user.id" :value="user.id">{{ user.username }} ({{ user.email }})</option>
    </select>
		</div>

		<div v-if="!noData">
    <div class="-mx-4 mt-8 sm:-mx-0">
      <table class="min-w-full divide-y divide-gray-300">
        <thead>
          <tr>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Id
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Start Time
            </th>

            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              End Time
            </th>
            
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Type
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr v-for="(value, index) in workingTimes" :key="value.id" class="even:bg-gray-50">

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ value.id }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Id</dt>
              </dl>
            </td>

            <td class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0 relative">
							<div class="flex items-center space-x-2">
								<span v-if="editingId !== value.id">{{ formatHoursMinutes(value.start_time) }}</span>
								<input
									v-if="editingId === value.id"
									v-model="editedTime"
									type="time"
									id="time-edit"
									class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
									required
									@input="(event) => handleInputChange(event, index)"

								/>
								<button @click="toggleEdit(value.id)" class="items-center gap-2 bg-gray-50 border border-gray-300 text-gray-900 px-4 py-2 rounded">
									<PencilIcon class="h-6" />
								</button>

							</div>
						</td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ formatHoursMinutes(value.end_time) }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">End Time</dt>
              </dl>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ value.type }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Type</dt>
              </dl>
            </td>

            <!-- <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
              <router-link
                :to="{ name: 'WorkingTimesManagerPage', params: { groupId: group.id } }"
                class="text-indigo-600 hover:text-indigo-900"
              >
                <EyeIcon class="h-6" />
              </router-link>
            </td> -->

          </tr>
        </tbody>
      </table>
    </div>
		</div>
		<div v-else-if="!selectedUserId" class="md:flex md:items-center md:justify-center mt-5">
			<h1>No user selected</h1>
		</div>
		<div v-else class="md:flex md:items-center md:justify-center mt-5">
			<h1>No data to display for selected dates</h1>
		</div>
  </div>
</template>

<style scoped></style>
