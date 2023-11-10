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
        :to="{ name: 'CreateGroup' }"
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
              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
                <router-link
                    :to="{ name: 'ShowGroup', params: { id: group.id } }"
                    class="text-indigo-600 hover:text-indigo-900"
                >
                  Show Group
                </router-link>
              </div>
              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
                <router-link
                    :to="{ name: 'UpdateGroup', params: { id: group.id }, state: {test: 'MON CUL'} }"
                    class="text-indigo-600 hover:text-indigo-900"
                >
                  Update Group
                </router-link>
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
import UpdateGroup from "@/components/users/UpdateGroup.vue";

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
</script>
