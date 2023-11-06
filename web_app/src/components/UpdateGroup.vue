<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-16 lg:px-8">
    <div>
      <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
        Manage your group!
      </h2>
    </div>
    <div class="mt-12 grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
      <div
        v-for="person in people"
        :key="person.email"
        class="relative flex items-center space-x-3 rounded-lg border border-gray-300 bg-white px-6 py-5 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-gray-400"
      >
        <div
          class="bg-indigo-500 flex w-10 h-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-medium text-white md:w-12 md:h-12"
        >
          {{ getInitials(person.username) }}
        </div>
        <div class="min-w-0 flex-1">
          <a href="#" class="focus:outline-none">
            <span class="absolute inset-0" aria-hidden="true"></span>
            <p class="text-sm font-medium text-gray-900">{{ person.username }}</p>
            <dd class="mt-3">
              <span
                class="inline-flex items-center rounded-full bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20"
                >{{ person.roles[0] }}</span
              >
            </dd>
          </a>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { strict } from 'assert'

interface User {
  username: string
  email: string
  roles: string[]
}

function getInitials(username: string): string {
  return username
    .split(' ')
    .map((name) => name[0])
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
