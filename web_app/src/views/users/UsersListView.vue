<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <h2 class="text-2xl font-bold tracking-tight text-gray-900 sm:text-3xl md:text-4xl">
          Users list
        </h2>
        <p class="mt-2 text-sm text-gray-700">
          A list of all users including their username, email and role
        </p>
      </div>
      <router-link
        :to="{ name: 'CreateUserPage' }"
        type="button"
        class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      >
        Create user
      </router-link>
    </div>
    <UserListComponent v-if="usersList.length > 0" :users="usersList" />
    <p v-else class="text-center text-4xl pt-4">No users to show you</p>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth.store'
import UserListComponent from '@/components/user/UserListComponent.vue'

const authStore = useAuthStore()

type User = {
  id: number
  email: string
  username: string
  role: 'EMPLOYEE' | 'MANAGER' | 'SUPER_MANAGER'
  group_id: number
}

const usersList = ref<User[] | []>([])

onMounted(async () => {
  usersList.value = await getUsers()
})

const getUsers = async (): Promise<User[] | []> => {
  const users = await axios.get('http://localhost:4000/api/users')
  return users.data.data
}
</script>
