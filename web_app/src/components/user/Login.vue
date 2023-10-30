<script setup lang="ts">
import { ref } from 'vue';
import UserForm from './AuthForm.vue';
import { useAuthStore } from "@/stores/auth.store";

const authStore = useAuthStore();
const showLoginForm = ref(true);

const loginUser = (data: { email: string; password: string }) => {
    authStore.login(data);
}

const isError = (value: unknown): value is Error => {
    return value instanceof Error;
};

const clearError = () => {
    authStore.error = null;
};
</script>

<template>
    <div v-if="!authStore.isAuthenticated">
        <button @click="showLoginForm = true">Login</button>
        <div v-show="showLoginForm">
            <UserForm formTitle="Login Form" submitLabel="Login" @form-submit="loginUser" />
            <div v-if="authStore.error" class="error-popup">
                <p class="error-message">{{ isError(authStore.error) ? authStore.error.message : authStore.error }}</p>
                <button @click="clearError" class="error-close-button">&times;</button>
            </div>
            <p>Don't have an account?</p>
            <RouterLink to="/register">Register</RouterLink>
        </div>
    </div>
</template>

<style scoped>
.error-popup {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #e53e3e;
    color: white;
    padding: 1rem;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.error-message {
    flex-grow: 1;
    margin-right: 1rem;
}

.error-close-button {
    cursor: pointer;
    background: none;
    border: none;
    color: white;
    font-size: 1.5rem;
}
</style>