<script setup lang="ts">
import {onMounted, ref} from 'vue';

import {useAuthStore} from "@/stores/auth.store";

const authStore = useAuthStore();

const username = ref<string>('');
const email = ref<string>('');
const password = ref<string>('');
const confirmPassword = ref<string>('');

type RuleFunction = (value: string) => boolean | string;

const passwordRules: RuleFunction[] = [
    (value) => !!value || 'Please type password.',
    (value) => (value && value.length >= 6) || 'minimum 6 characters'
]

const confirmPasswordRules: RuleFunction[] = [
    (value) => !!value || 'type confirm password',
    (value) => value === password.value || 'The password confirmation does not match.'
]

const updateProfile = async (): Promise<void> => {
    authStore.updateUser({
        id: authStore.id,
        username: username.value,
        email: email.value,
    })
}

const updateProfilePassword = async (): Promise<void> => {
    authStore.updateUserPassword({
        id: authStore.id,
        password: password.value,
    })
}

onMounted(async() => {
    await authStore.checkAuth()
    console.log(authStore.username);
    console.log(authStore.email);
    if (authStore.user) {
        username.value = authStore.username;
        email.value = authStore.email;
    }})
</script>

<template>
    <div class="flex flex-col items-center justify-center p-4">
        <form @submit.prevent="updateProfile" class="bg-white p-6 rounded shadow-md">
            <div class="mb-4">
                <label for="username" class="block text-sm font-medium text-gray-700">Username:</label>
                <input type="text" id="username" v-model="username" required class="mt-1 p-2 w-full border rounded-md text-black" />
            </div>
            <div class="mb-4">
                <label for="email" class="block text-sm font-medium text-gray-700">Email:</label>
                <input type="email" id="email" v-model="email" required class="mt-1 p-2 w-full border rounded-md text-black" />
            </div>
            <button type="submit" class="w-full p-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">Update Profile</button>
        </form>
    </div>
    <div class="flex flex-col items-center justify-center p-4">
        <form @submit.prevent="updateProfilePassword" class="bg-white p-6 rounded shadow-md">
            <div class="mb-4">
                <label for="password" class="block text-sm font-medium text-gray-700">Password:</label>
                <input type="password" id="password" v-model="password" :rules="passwordRules" prepend-icon="mdi-lock" required class="mt-1 p-2 w-full border rounded-md text-black" />
            </div>
            <div class="mb-4">
                <label for="confirmPassword" class="block text-sm font-medium text-gray-700">Confirm password:</label>
                <input type="password" id="confirmPassword" v-model="confirmPassword" :rules="confirmPasswordRules" prepend-icon="mdi-lock" required class="mt-1 p-2 w-full border rounded-md text-black" />
            </div>
            <button type="submit" class="w-full p-2 bg-blue-500 text-white rounded-md hover:bg-blue-600">Update Password</button>
        </form>
    </div>
</template>
