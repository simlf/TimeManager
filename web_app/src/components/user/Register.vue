<script setup lang="ts">
import AuthForm from './AuthForm.vue'
import { useAuthStore } from '@/stores/auth.store'
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'
import { useRoute } from 'vue-router'
import router from '@/router'

const authStore = useAuthStore()
const route = useRoute()

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()
const createUser = (data: { username: string; email: string; password: string }) => {
  if (authStore.isSuperManager && route.params.groupId) {
    data['group_id'] = Number(route.params.groupId)
  }
  authStore.register(data)
}
const roles = ['EMPLOYEE', 'MANAGER']
</script>

<template>
  <div class="flex flex-col items-center mt-2">
    <div class="w-full sm:w-1/8 md:w-1/8 lg:w-1/8 xl:w-1/8">
      <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
      <AlertBox
        v-if="authStore.success"
        type="success"
        :message="successMessage"
        @dismiss="clearSuccess"
      />
      <AuthForm
        formTitle="Create a user for your group"
        submitLabel="Create User"
        :roles="roles"
        @form-submit="createUser"
      />
      <div class="text-center">
        <button
          type="button"
          class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500"
          @click="router.go(-1)"
        >
          Go Back
        </button>
      </div>
    </div>
  </div>
</template>
