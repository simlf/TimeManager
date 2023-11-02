<script setup lang="ts">
import { ref } from 'vue';
import UserForm from './AuthForm.vue';
import { useAuthStore } from "@/stores/auth.store";
import AlertBox from '@/components/utils/AlertBox.vue';
import useMessageHandling from "@/composables/useMessageHandling";

const authStore = useAuthStore();
const showLoginForm = ref(true);

const { clearError, clearSuccess, errorMessage, successMessage } = useMessageHandling();

const loginUser = (data: { email: string; password: string }) => {
    authStore.login(data);
}

</script>

<template>
    <div v-if="!authStore.isAuthenticated">
        <!-- <button @click="showLoginForm = true">Login</button> -->
        <div v-show="showLoginForm">
            <UserForm formTitle="Login" submitLabel="Login" @form-submit="loginUser" />
            <AlertBox v-if="authStore.error" type="error" :message="errorMessage" @dismiss="clearError" />
            <AlertBox v-if="authStore.success" type="success" :message="successMessage" @dismiss="clearSuccess" />

            <p class="text-center text-sm text-gray-500">
                Don't have an account ?
                {{ ' ' }}
                <RouterLink class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500" to="/register">Register</RouterLink>
            </p>
        </div>
    </div>
</template>