<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { EyeIcon } from '@heroicons/vue/20/solid'
import { useAuthStore } from '@/stores/auth.store'

const authStore = useAuthStore()

type Group = {
  id: number
  name: string
  count_users: number
}

const groups = ref<Group[] | []>([])

onMounted(async () => {
  groups.value = await getGroups()
})

const getGroups = async (): Promise<Group[] | []> => {
  const groups = await axios.get('http://localhost:4000/api/groups')
  return groups.data.data
}

function getInitials(group_name: string): string {
  return group_name
    .split(' ')
    .map((group_name) => group_name[0])
    .join('')
    .toUpperCase()
}

const tabs = [
  { name: 'Default View', href: '/workingTimes/', current: false, hidden: false },
  { name: 'Manager View', href: '/workingTimesManager/', current: false, hidden: authStore.isSuperManager },
  { name: 'SuperManager View', href: '/workingTimesSuperManager', current: true, hidden: false },
  { name: 'Editor', href: '/workingTimesEditor/', current: false, hidden: !authStore.isSuperManager },
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

    <!-- Table group users -->
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <!-- <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Groups
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all the users in your group including their username, email and role.
        </p> -->
      </div>
    </div>
    <div class="-mx-4 mt-8 sm:-mx-0">
      <table class="min-w-full divide-y divide-gray-300">
        <thead>
          <tr>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Avatar
            </th>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Name
            </th>
            
            <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-0">
              <span class="sr-only">Check group</span>
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr v-for="group in groups" :key="group.id" class="even:bg-gray-50">
            <td class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0">
              <div class="flex items-center">
                <div
                  class="bg-indigo-500 flex w-10 h-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-medium text-white md:w-12 md:h-12"
                >
                  {{ getInitials(group.name) }}
                </div>
              </div>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ group.name }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Title</dt>
              </dl>
            </td>


            <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
              <router-link
                :to="{ name: 'WorkingTimesManagerPage', params: { groupId: group.id } }"
                class="text-indigo-600 hover:text-indigo-900"
              >
                <EyeIcon class="h-6" />
              </router-link>
              
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped></style>
