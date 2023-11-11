<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <router-link
          v-if="authStore.isSuperManager"
          :to="{ name: 'GroupsList' }"
          class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500"
          >Go Back</router-link
        >
        <h2
          v-if="groupState"
          class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl"
        >
          {{ groupState.group.name }}
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all the users in your group including their username, email and role.
        </p>
      </div>
      <!--        </button>-->
      <!--        <router-link-->
      <!--            class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"-->
      <!--            to="/register"-->
      <!--        >-->
      <!--          Create user-->
      <!--        </router-link>-->
      <!--      </div>-->
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
            <th
              scope="col"
              class="hidden px-3 py-3.5 text-left text-sm font-semibold text-gray-900 sm:table-cell"
            >
              Email
            </th>
            <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-gray-900">
              Role
            </th>
            <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-0">
              <span class="sr-only">Edit</span>
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 bg-white">
          <tr
            v-if="groupState"
            v-for="user in groupState.users"
            :key="user.id"
            class="even:bg-gray-50"
          >
            <td class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0">
              <div class="flex items-center">
                <div
                  class="bg-indigo-500 flex w-10 h-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-medium text-white md:w-12 md:h-12"
                >
                  {{ getInitials(user.username) }}
                </div>
              </div>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ user.username }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Title</dt>
                <dt class="sr-only sm:hidden">Email</dt>
                <dd class="mt-1 truncate text-gray-500 sm:hidden">{{ user.email }}</dd>
              </dl>
            </td>
            <td class="hidden px-3 py-4 text-sm text-gray-500 sm:table-cell">{{ user.email }}</td>
            <td class="px-3 py-4 text-sm text-gray-500">{{ user.role }}</td>
            <td class="flex justify-end py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
              <!--              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium">-->
              <!--                <router-link-->
              <!--                    :to="{ name: 'ShowGroup' }"-->
              <!--                    class="text-indigo-600 hover:text-indigo-900"-->
              <!--                >-->
              <!--                  <EyeIcon class="h-6" />-->
              <!--                </router-link>-->
              <!--              </div>-->
              <!--              <div class="py-4 pl-3 pr-4 text-right text-sm font-medium">-->
              <!--                <router-link-->
              <!--                    :to="{ name: 'UpdateGroup' }"-->
              <!--                    class="text-orange-500 hover:text-indigo-900"-->
              <!--                >-->
              <!--                  <AdjustmentsVerticalIcon class="h-6" />-->
              <!--                </router-link>-->
              <!--              </div>-->
              <div
                v-if="authStore.isSuperManager"
                class="py-4 pl-3 pr-4 text-right text-sm font-medium"
              >
                <button
                  type="button"
                  class="text-red-600 hover:text-indigo-900"
                  @click="removeUserFromGroup(user.id)"
                >
                  <UserMinusIcon class="h-6" />
                </button>
              </div>
              <!--            <button-->
              <!--                @click="openEditUserModal(person)"-->
              <!--                class="text-indigo-600 hover:text-indigo-900"-->
              <!--            >-->
              <!--              Edit-->
              <!--            </button>-->
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import User from '@/components/user/User.vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth.store'
import { AdjustmentsVerticalIcon, EyeIcon, UserMinusIcon } from '@heroicons/vue/20/solid'

const route = useRoute()
const authStore = useAuthStore()

type User = {
  id: number
  email: string
  username: string
  role: 'SUPER_MANAGER' | 'MANAGER' | 'EMPLOYEE'
}

interface Group {
  group: {
    id: number
    name: string
  }
  users: User[]
}

const groupState = ref<Group>()

onMounted(async () => {
  groupState.value = await getGroupById()
})

function getInitials(username: string): string {
  return username
    .split(' ')
    .map((username) => username[0])
    .join('')
    .toUpperCase()
}

const getGroupById = async (): Promise<Group> => {
  const group = await axios.get('http://localhost:4000/api/groups/' + route.params.id)
  return group.data.data
}

const removeUserFromGroup = async (userId: number): Promise<void> => {
  try {
    const removeUser = await axios.patch(
      'http://localhost:4000/api/groups/' + route.params.id + '/' + userId
    )
    if (removeUser.status === 200) {
      groupState.value = await getGroupById()
    }
  } catch (e) {
    console.log('Something wrong happens during deletion')
  }
}
</script>
