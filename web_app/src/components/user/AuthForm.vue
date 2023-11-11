<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <img class="mx-auto h-20 w-auto" src="/appLogo.png" alt="Time Manager Logo" />
      <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900">
        {{ formTitle }}
      </h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <div v-if="submitLabel === 'Create User'">
          <label for="username" class="block text-sm font-medium leading-6 text-gray-900"
            >Username</label
          >
          <div class="mt-2">
            <input
              v-model="formInfo.username"
              name="username"
              type="text"
              autocomplete="text"
              placeholder="Jean007"
              required
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            />
          </div>
        </div>
        <div v-if="authStore.isSuperManager" class="w-full">
          <label class="typo__label">Role</label>
          <multiselect
            v-model="formInfo.role"
            :options="roles"
            :searchable="false"
            :close-on-select="true"
            :show-labels="true"
            placeholder="Pick a value"
          ></multiselect>
        </div>
        <div>
          <label for="email" class="block text-sm font-medium leading-6 text-gray-900"
            >Email address</label
          >
          <div class="mt-2">
            <input
              v-model="formInfo.email"
              name="email"
              type="email"
              autocomplete="email"
              placeholder="jean007@gmail.com"
              required
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            />
          </div>
        </div>

        <div>
          <div class="flex items-center justify-between">
            <label for="password" class="block text-sm font-medium leading-6 text-gray-900"
              >Password</label
            >
          </div>
          <div class="mt-2">
            <input
              v-model="formInfo.password"
              name="password"
              type="password"
              autocomplete="current-password"
              placeholder="Password"
              required
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
            />
          </div>
        </div>
        <div>
          <button
            type="submit"
            class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            {{ submitLabel }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useAuthStore } from '@/stores/auth.store'
import Multiselect from 'vue-multiselect'

const authStore = useAuthStore()

defineProps({
  formTitle: {
    type: String,
    required: true
  },
  submitLabel: {
    type: String,
    required: true
  },
  roles: {
    type: Array,
    required: false
  }
})

interface FormInfo {
  username?: string
  email: string
  password: string
  role?: string
}

const formInfo: FormInfo = ref({
  username: '',
  email: '',
  password: '',
  role: ''
})

const emit = defineEmits()
const handleSubmit = () => {
  emit('form-submit', formInfo.value)
}
</script>
