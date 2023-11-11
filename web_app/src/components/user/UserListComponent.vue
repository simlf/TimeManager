<template>
  <div class="-mx-4 mt-8 sm:-mx-0">
    <AlertBox v-if="errorRequest" type="error" :message="errorRequest" @dismiss="clearError" />
    <AlertBox
      v-if="successRequest"
      type="success"
      :message="successRequest"
      @dismiss="clearSuccess"
    />
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
        <tr v-if="users" v-for="user in users" :key="user.id" class="even:bg-gray-50">
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
          <td
            v-if="user.role !== 'SUPER_MANAGER'"
            class="flex justify-end py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-0"
          >
            <!-- TODO: ENZO -> Envoyer sur la page pour voir les workingTime de l'utilisateur -->
            <div
              v-if="authStore.isSuperManager || (authStore.isManager && user.role !== 'MANAGER')"
              class="py-4 pl-3 pr-4 text-right text-sm font-medium"
            >
              <router-link
                :to="{ name: '', params: { userId: user.id } }"
                class="text-indigo-600 hover:text-indigo-900"
              >
                <EyeIcon class="h-6" />
              </router-link>
            </div>
            <div
              v-if="authStore.isSuperManager || (authStore.isManager && user.role !== 'MANAGER')"
              class="py-4 pl-3 pr-4 text-right text-sm font-medium"
            >
              <button
                @click="openEditUserModal(user)"
                type="button"
                class="text-orange-500 hover:text-indigo-900"
              >
                <AdjustmentsVerticalIcon class="h-6" />
              </button>
            </div>
            <div
              v-if="authStore.isSuperManager && route.fullPath.includes('group')"
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
            <div
              v-if="authStore.isSuperManager && route.fullPath.includes('users')"
              class="py-4 pl-3 pr-4 text-right text-sm font-medium"
            >
              <button
                type="button"
                class="text-red-600 hover:text-indigo-900"
                @click="deleteUser(user.id)"
              >
                <TrashIcon class="h-6" />
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
    <UpdateUserModal
      v-if="currentUser"
      :isUpdateUserModalOpen="isUpdateUserModalOpen"
      :initialUsername="currentUser.username"
      :initialEmail="currentUser.email"
      :initialRole="currentUser.role"
      :initialGroupId="currentUser.group_id"
      :userId="currentUser.id"
      @update:isUpdateUserModalOpen="isUpdateUserModalOpen = $event"
    />
  </div>
</template>

<script setup lang="ts">
import { TrashIcon, UserMinusIcon, EyeIcon, AdjustmentsVerticalIcon } from '@heroicons/vue/20/solid'
import axios from 'axios'
import { useRoute } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'
import { ref, watch } from 'vue'
import UpdateUserModal from '@/components/user/UpdateUserModal.vue'
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'

const { clearError, clearSuccess } = useMessageHandling()
const route = useRoute()
const authStore = useAuthStore()

type User = {
  id: number
  email: string
  username: string
  role: 'SUPER_MANAGER' | 'MANAGER' | 'EMPLOYEE'
  group_id?: number
}

const isUpdateUserModalOpen = ref(false)
const currentUser = ref<User>()
const errorRequest = ref<string>('')
const successRequest = ref<string>('')

const { users } = defineProps<{
  users: User[]
}>()

watch(
  () => users,
  () => {}
)

function getInitials(username: string): string {
  return username
    .split(' ')
    .map((username) => username[0])
    .join('')
    .toUpperCase()
}

function openEditUserModal(user: User) {
  currentUser.value = user
  isUpdateUserModalOpen.value = true
}

const removeUserFromGroup = async (userId: number): Promise<void> => {
  try {
    const removeUser = await axios.patch(
      'http://localhost:4000/api/groups/' + route.params.id + '/' + userId
    )
    if (removeUser.status === 200) {
      successRequest.value = 'User remove from the group !'
      users.splice(
        users.findIndex((u) => u.id === userId),
        1
      )
    }
  } catch (e) {
    console.log('Something wrong happens during deletion')
  }
}

const deleteUser = async (userId: number): Promise<void> => {
  try {
    const deleteUser = await axios.delete('http://localhost:4000/api/users/' + userId)
    if (deleteUser.status === 204) {
      successRequest.value = 'User deleted !'
      users.splice(
        users.findIndex((u) => u.id === userId),
        1
      )
    }
  } catch (e) {
    console.log('Something wrong happens during deletion')
  }
}
</script>
