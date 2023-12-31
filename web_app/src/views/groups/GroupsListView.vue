<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Groups list
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all the groups including their name and the number of user
        </p>
      </div>
      <router-link
        :to="{ name: 'CreateGroupPage' }"
        type="button"
        class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      >
        Create group
      </router-link>
    </div>
    <div class="-mx-4 mt-8 sm:-mx-0">
      <table class="min-w-full divide-y divide-gray-300">
        <thead>
          <tr>
            <th
              scope="col"
              class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-0"
            >
              Name
            </th>
            <th
              scope="col"
              class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 sm:table-cell"
            >
              Number of user
            </th>
            <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-0">
              <span class="sr-only">Edit</span>
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr v-for="group in groups" :key="group.id" class="even:bg-gray-50">
            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ group.name }}
            </td>
            <td class="px-3 py-4 text-sm text-gray-500">{{ group.count_users }}</td>
            <td class="flex justify-end">
              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium">
                <router-link
                  :to="{ name: 'ShowGroupPage', params: { id: group.id } }"
                  class="text-indigo-600 hover:text-indigo-900"
                >
                  <EyeIcon class="h-6" />
                </router-link>
              </div>
              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium">
                <router-link
                  :to="{ name: 'UpdateGroupPage', params: { id: group.id } }"
                  class="text-orange-500 hover:text-indigo-900"
                >
                  <AdjustmentsVerticalIcon class="h-6" />
                </router-link>
              </div>
              <div
                v-if="authStore.isSuperManager"
                class="py-4 pl-3 pr-4 text-right text-sm font-medium"
              >
                <button
                  type="button"
                  class="text-red-600 hover:text-indigo-900"
                  @click="deleteGroup(group.id)"
                >
                  <TrashIcon class="h-6" />
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { EyeIcon, AdjustmentsVerticalIcon, TrashIcon } from '@heroicons/vue/20/solid'
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

const deleteGroup = async (id: number): Promise<void> => {
  try {
    const deleteGroup = await axios.delete('http://localhost:4000/api/groups/' + id)
    if (deleteGroup.status === 204) {
      groups.value = await getGroups()
    }
  } catch (e) {
    console.log('Something wrong happens during deletion')
  }
}
</script>
