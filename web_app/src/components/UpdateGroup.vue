<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Groups
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all the users in your group including their username, email and role.
        </p>
      </div>
      <div class="mt-4 sm:ml-16 sm:mt-0 sm:flex-none">
        <button
          type="button"
          class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          Add user
        </button>
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
          <tr v-for="person in people" :key="person.email" class="even:bg-gray-50">
            <td class="whitespace-nowrap py-5 pl-4 pr-3 text-sm sm:pl-0">
              <div class="flex items-center">
                <div
                  class="bg-indigo-500 flex w-10 h-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-medium text-white md:w-12 md:h-12"
                >
                  {{ getInitials(person.username) }}
                </div>
              </div>
            </td>

            <td
              class="w-full max-w-0 py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:w-auto sm:max-w-none sm:pl-0"
            >
              {{ person.username }}
              <dl class="font-normal lg:hidden">
                <dt class="sr-only">Title</dt>
                <dt class="sr-only sm:hidden">Email</dt>
                <dd class="mt-1 truncate text-gray-500 sm:hidden">{{ person.email }}</dd>
              </dl>
            </td>
            <td class="hidden px-3 py-4 text-sm text-gray-500 sm:table-cell">{{ person.email }}</td>
            <td class="px-3 py-4 text-sm text-gray-500">{{ person.roles[0] }}</td>
            <td class="py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0">
              <button @click="openModal(person)" class="text-indigo-600 hover:text-indigo-900">
                Edit
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <UpdateUserGroup
      :isModalOpen="isModalOpen"
      :initialUsername="currentUser.username"
      :initialEmail="currentUser.email"
      @update:isModalOpen="isModalOpen = $event"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import UpdateUserGroup from '@/components/UpdateUserGroup.vue'
import User from '@/components/user/User.vue'

const isModalOpen = ref(false)

interface User {
  username: string
  email: string
  roles: string[]
}

const currentUser = ref(User)

function openModal(user: User) {
  currentUser.value = user
  isModalOpen.value = true
}

function getInitials(username: string): string {
  return username
    .split(' ')
    .map((username) => username[0])
    .join('')
    .toUpperCase()
}

const people: { roles: string[]; email: string; username: string }[] = [
  {
    username: 'Leslie Alexander',
    email: 'leslie.alexander@example.com',
    roles: ['Employee']
  },
  {
    username: 'Leslie Alexander',
    email: 'leslie.alexander@example.com',
    roles: ['Employee']
  },
  {
    username: 'Alexandre',
    email: 'leslie.alexander@example.com',
    roles: ['Employee']
  }
]
</script>
