<template>
  <div class="mx-auto max-w-7xl px-6 py-12 sm:py-10 lg:px-8">
    <div class="sm:flex sm:items-center">
      <div class="sm:flex-auto">
        <BackLinkComponent />
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
      <router-link
        v-if="authStore.isManager"
        class="mr-3 block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        :to="{ name: 'UpdateGroupPage', params: { id: route.params.id } }"
      >
        Update group
      </router-link>
      <router-link
        class="block rounded-md bg-indigo-600 px-3 py-2 text-center text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        :to="{ name: 'CreateUserPage', params: { groupId: route.params.id } }"
      >
        Create user
      </router-link>
    </div>
    <UserListComponent v-if="groupState" :users="groupState.users" />
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref } from 'vue'
import User from '@/components/user/User.vue'
import { useRoute } from 'vue-router'
import axios from 'axios'
import { useAuthStore } from '@/stores/auth.store'
import UserListComponent from '@/components/user/UserListComponent.vue'
import BackLinkComponent from '@/components/BackLinkComponent.vue'

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

const getGroupById = async (): Promise<Group> => {
  const group = await axios.get('http://localhost:4000/api/groups/' + route.params.id)
  return group.data.data
}
</script>
