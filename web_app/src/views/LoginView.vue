<script setup lang="ts">
import AuthForm from '../components/user/AuthForm.vue'
import { useAuthStore } from '@/stores/auth.store'
import AlertBox from '@/components/utils/AlertBox.vue'
import useMessageHandling from '@/composables/useMessageHandling'

const authStore = useAuthStore()

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling()

const loginUser = (data: { email: string; password: string }) => {
  authStore.login(data)
}
</script>

<template>
  <div class="flex flex-col items-center mt-2">
    <div class="login-container w-full sm:w-1/8 md:w-1/8 lg:w-1/8 xl:w-1/8">
      <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
      <AlertBox
        v-if="authStore.success"
        type="success"
        :message="successMessage"
        @dismiss="clearSuccess"
      />
      <AuthForm formTitle="Login" submitLabel="Login" @form-submit="loginUser" />
      <p class="text-center text-sm text-gray-500">
        Don't have an account yet ?
        {{ ' ' }}
        <span class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500">
          Ask your manager to create one for you
        </span>
      </p>
    </div>
  </div>
</template>
