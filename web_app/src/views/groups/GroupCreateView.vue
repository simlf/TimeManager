<script setup lang="ts">
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'
import GroupForm from '@/components/group/GroupForm.vue'
import axios from 'axios'
import { ref } from 'vue'
import router from '@/router'
import BackLinkComponent from '@/components/BackLinkComponent.vue'

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()
const errorRequest = ref<string>('')
const createGroup = async (data: { name: string; employees: number[]; managers: number[] }) => {
  try {
    await axios.post('http://localhost:4000/api/groups', data)
    await router.push({ name: 'GroupsListPage' })
  } catch (error: Error | any) {
    console.log(error)
  }
}
</script>

<template>
  <div class="flex flex-col items-center mt-2">
    <div class="w-full sm:w-1/8 md:w-1/8 lg:w-1/8 xl:w-1/8">
      <AlertBox v-if="errorRequest" type="error" :message="errorRequest" @dismiss="clearError" />
      <GroupForm formTitle="Create a group" submitLabel="Create" @group-form-submit="createGroup" />
      <div class="text-center">
        <BackLinkComponent />
      </div>
    </div>
  </div>
</template>
