<script setup lang="ts">
import AuthForm from './AuthForm.vue'
import { useAuthStore } from '@/stores/auth.store'
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'

const authStore = useAuthStore()

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()
const createUser = (data: { username: string; email: string; password: string }) => {
  authStore.register(data)
}

</script>

<template>
  <div v-if="!authStore.isAuthenticated">
    <div>
      <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
      <AlertBox
        v-if="authStore.success"
        type="success"
        :message="successMessage"
        @dismiss="clearSuccess"
      />
      <AuthForm formTitle="Register" submitLabel="Register" @form-submit="createUser" />
    </div>
    <div class="mt-1">
      <RouterLink to="/login" class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Go Back</RouterLink>
    </div>
  </div>
</template>
