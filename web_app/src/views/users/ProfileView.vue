<script setup lang="ts">
import { onMounted, ref } from 'vue'
import AlertBox from '@/components/utils/AlertBox.vue'
import { useAuthStore } from '@/stores/auth.store'
import useMessageHandling from '@/composables/useMessageHandling'

const authStore = useAuthStore()

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()

const username = ref<string>('')
const email = ref<string>('')
const password = ref<string>('')

const updateProfile = async (): Promise<void> => {
  authStore.updateUser({
    id: authStore.id,
    username: username.value,
    email: email.value
  })
}

const updateProfilePassword = async (): Promise<void> => {
  console.log(password.value)

  authStore.updateUserPassword({
    id: authStore.id,
    password: password.value
  })
}

onMounted(async () => {
  await authStore.checkAuth()

  if (authStore.user) {
    username.value = authStore.username
    email.value = authStore.email
  }
})
</script>

<template>
  <div class="mx-auto max-w-7xl px-6 py-24 sm:py-32 lg:px-8">
    <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
    <AlertBox
      v-if="authStore.success"
      type="success"
      :message="successMessage"
      @dismiss="clearSuccess"
    />
    <div class="bg-white shadow sm:rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <h3 class="text-base font-semibold leading-6 text-gray-900">
          Update your username or password
        </h3>
        <div class="mt-2 max-w-xl text-sm text-gray-500">
          <p>Change the username or password you want associated with your account.</p>
        </div>
        <form @submit.prevent="updateProfile" class="mt-5 sm:flex sm:items-center">
          <div class="w-full sm:max-w-xs">
            <label for="username" class="sr-only"></label>
            <input
              type="text"
              name="username"
              v-model="username"
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              placeholder="Username"
            />
          </div>
          <div class="w-full sm:max-w-xs">
            <label for="email" class="sr-only">Email</label>
            <input
              type="email"
              name="email"
              v-model="email"
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              placeholder="Email"
            />
          </div>
          <button
            type="submit"
            class="mt-3 inline-flex w-full items-center justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 sm:ml-3 sm:mt-0 sm:w-auto"
          >
            Save
          </button>
        </form>
      </div>
    </div>
    <div class="bg-white shadow sm:rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <h3 class="text-base font-semibold leading-6 text-gray-900">Update your password</h3>
        <div class="mt-2 max-w-xl text-sm text-gray-500">
          <p>Change the password you want associated with your account.</p>
        </div>
        <form @submit.prevent="updateProfilePassword" class="mt-5 sm:flex sm:items-center">
          <div class="w-full sm:max-w-xs">
            <label for="password" class="sr-only">Password</label>
            <input
              type="password"
              name="password"
              v-model="password"
              class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
              placeholder="Password"
            />
          </div>
          <button
            type="submit"
            class="mt-3 inline-flex w-full items-center justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 sm:ml-3 sm:mt-0 sm:w-auto"
          >
            Save
          </button>
        </form>
      </div>
    </div>
  </div>
</template>
