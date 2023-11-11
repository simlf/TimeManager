<script setup lang="ts">
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'
import GroupForm from '@/components/group/GroupForm.vue'
import axios from 'axios'
import { onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import router from '@/router'
import BackLinkComponent from '@/components/BackLinkComponent.vue'

const route = useRoute()
const { clearError, clearSuccess } = useMessageHandling()
const errorRequest = ref<string>('')
const successRequest = ref<string>('')
const groupState = ref<Group>()

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

onMounted(async () => {
  groupState.value = await getGroupById()
})

const updateGroup = async (data: { name: string; employees: number[]; managers: number[] }) => {
  try {
    await axios.put('http://localhost:4000/api/groups/' + route.params.id, data)
    successRequest.value = "Group udpated, you'll be redirect ..."
    setTimeout(() => {
      router.push({ name: 'GroupsListPage' })
    }, 3000)
  } catch (error: Error | any) {
    console.log(error)
  }
}

const getGroupById = async (): Promise<Group> => {
  const group = await axios.get('http://localhost:4000/api/groups/' + route.params.id)
  return group.data.data
}
</script>

<template>
  <div class="flex flex-col items-center mt-2">
    <div class="w-full sm:w-1/8 md:w-1/8 lg:w-1/8 xl:w-1/8">
      <AlertBox v-if="errorRequest" type="error" :message="errorRequest" @dismiss="clearError" />
      <AlertBox
        v-if="successRequest"
        type="success"
        :message="successRequest"
        @dismiss="clearSuccess"
      />
      <GroupForm
        v-if="groupState"
        :formTitle="`Update ${groupState.group.name}`"
        :groupName="groupState.group.name"
        submitLabel="Update"
        @group-form-submit="updateGroup"
      />
      <div class="text-center">
        <BackLinkComponent />
      </div>
    </div>
  </div>
</template>
