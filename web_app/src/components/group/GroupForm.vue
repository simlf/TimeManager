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
        <label for="name" class="block text-sm font-medium leading-6 text-gray-900"
          >Group name</label
        >
        <div class="mt-2">
          <input
            v-model="formInfo.name"
            name="name"
            type="text"
            autocomplete="text"
            placeholder="Gotham Group"
            required
            class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
          />
        </div>
        <label for="name" class="block text-sm font-medium leading-6 text-gray-900"
          >Employees</label
        >
        <multiselect
          v-if="filteredResult && filteredResult.employee"
          :close-on-select="false"
          v-model="tempEmployees"
          :options="filteredResult.employee"
          :multiple="true"
          group-values="users"
          group-label="role"
          :group-select="true"
          placeholder="Type to search"
          track-by="id"
          label="email"
          ><span slot="noResult"
            >Oops! No elements found. Consider changing the search query.</span
          ></multiselect
        >
        <label
          v-if="authStore.isSuperManager"
          for="name"
          class="block text-sm font-medium leading-6 text-gray-900"
          >Managers</label
        >
        <multiselect
          v-if="filteredResult && filteredResult.manager && authStore.isSuperManager"
          :close-on-select="false"
          v-model="tempManagers"
          :options="filteredResult.manager"
          :multiple="true"
          group-values="users"
          group-label="role"
          :group-select="true"
          placeholder="Type to search"
          track-by="id"
          label="email"
          ><span slot="noResult"
            >Oops! No elements found. Consider changing the search query.</span
          ></multiselect
        >
        <button
          type="submit"
          class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm font-semibold leading-6 text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
        >
          {{ submitLabel }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import Multiselect from 'vue-multiselect'
import { useAuthStore } from '@/stores/auth.store'
import { onMounted, Ref, ref } from 'vue'
import axios from 'axios'
import { useRoute } from 'vue-router'

const authStore = useAuthStore()
const route = useRoute()

interface FormInfoGroup {
  name: string
  employees: number[]
  managers: number[]
}

type SelectItem = {
  role: string
  users: {
    email: string
    id: number
  }[]
}

type User = {
  id: number
  email: string
  username: string
  role: 'SUPER_MANAGER' | 'MANAGER' | 'EMPLOYEE'
  group_id: number
}

interface FilteredResult {
  manager?: SelectItem[]
  employee?: SelectItem[]
}

const { formTitle, submitLabel, groupName } = defineProps({
  formTitle: {
    type: String,
    required: true
  },
  submitLabel: {
    type: String,
    required: true
  },
  groupName: {
    type: String,
    required: false
  }
})

const filteredResult = ref<FilteredResult>()
const tempManagers = ref<{ email: string; id: number }[]>([])
const tempEmployees = ref<{ email: string; id: number }[]>([])

const formInfo: Ref<FormInfoGroup> = ref({
  name: groupName ?? '',
  employees: [],
  managers: []
})

onMounted(async () => {
  filteredResult.value = await getResultFilter()
})

const getUsers = async (): Promise<User[] | []> => {
  const url = authStore.isSuperManager
    ? 'http://localhost:4000/api/users'
    : 'http://localhost:4000/api/users/employees_list'
  const users = await axios.get(url)
  return users.data.data
}

const filterUsersDataForSuperManager = async (): Promise<SelectItem[]> => {
  const filter: SelectItem[] = []
  const users = await getUsers()

  if (users && users.length > 0) {
    users.forEach((user) => {
      if (user.role !== 'SUPER_MANAGER') {
        if (!route.params.id || Number(route.params.id) !== user.group_id) {
          let role = user.group_id ? user.role + ' on groups' : user.role
          role = role.toLowerCase()

          let existingRoleObject = filter.find((item) => item.role === role)

          if (!existingRoleObject) {
            existingRoleObject = { role: role, users: [] }
            filter.push(existingRoleObject)
          }

          existingRoleObject.users.push({ email: user.username, id: user.id })
        }
      }
    })
  }

  return filter
}

const getResultFilter = async (): Promise<FilteredResult> => {
  const filter = await filterUsersDataForSuperManager()
  const result: FilteredResult = {}

  filter.forEach((obj) => {
    if (obj.role.includes('manager')) {
      if (!result.manager) result.manager = []
      result.manager.push(obj)
    } else {
      if (!result.employee) result.employee = []
      result.employee.push(obj)
    }
  })

  return result
}

const emit = defineEmits()
const handleSubmit = () => {
  if (tempManagers.value.length > 0 && authStore.isSuperManager) {
    tempManagers.value.forEach((manager) => {
      formInfo.value.managers.push(manager.id)
    })
  }
  if (tempEmployees.value.length > 0) {
    tempEmployees.value.forEach((employee) => {
      formInfo.value.employees.push(employee.id)
    })
  }

  const data = {
    group: formInfo.value
  }
  emit('group-form-submit', data)
}
</script>
