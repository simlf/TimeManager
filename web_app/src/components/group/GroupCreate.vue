<script setup lang="ts">
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'
import GroupForm from '@/components/group/GroupForm.vue'
import axios from 'axios'
import { ref } from 'vue'
import router from '@/router'

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()
const errorRequest = ref<string>('')
const createGroup = async (data: { name: string; employees: number[]; managers: number[] }) => {
  try {
    await axios.post('http://localhost:4000/api/groups', data)
    await router.push({ name: 'GroupsList' })
  } catch (error: Error | any) {
    console.log(error)
  }
}
</script>

<template>
  <div class="flex flex-col items-center mt-2">
    <div class="w-full sm:w-1/8 md:w-1/8 lg:w-1/8 xl:w-1/8">
      <AlertBox v-if="errorRequest" type="error" :message="errorRequest" @dismiss="clearError" />
      <GroupForm
        formTitle="Create a group"
        submitLabel="Create Group"
        @group-form-submit="createGroup"
      />
      <div class="text-center">
        <RouterLink
          to="/GroupsList"
          class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500"
          >Go Back</RouterLink
        >
      </div>
    </div>
  </div>
</template>
