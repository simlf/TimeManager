<script setup lang="ts">
import UserForm from './AuthForm.vue';
import { useAuthStore } from "@/stores/auth.store";
import AlertBox from "@/components/utils/AlertBox.vue";
import useMessageHandling from "@/composables/useMessageHandling";

const authStore = useAuthStore();

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling();
const createUser = (data: { username: string, email: string; password: string }) => {
    authStore.register(data);
}
</script>

<template>
  <div v-if="!authStore.isAuthenticated">
    <div>
        <UserForm formTitle="Register" submitLabel="Register" @form-submit="createUser" />
        <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
        <AlertBox v-if="authStore.success" type="success" :message="successMessage" @dismiss="clearSuccess" />
    </div>
  </div>
</template>