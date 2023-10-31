<template>
  <div class="max-w-md mx-auto">
    <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
      <h2 class="text-2xl mb-6 text-green-500">{{ formTitle }}</h2>
        <div v-if="submitLabel === 'Register'" class="mb-4">
            <label class="block text-gray-700 text-sm font-bold mb-2" for="email">Username:</label>
            <input v-model="formInfo.username" type="text" placeholder="Jean001" required
                   class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
        </div>

        <div class="mb-4">
        <label class="block text-gray-700 text-sm font-bold mb-2" for="email">Email:</label>
        <input v-model="formInfo.email" type="text" placeholder="jean@gmail.com" required
               class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
      </div>

      <div class="mb-6">
        <label class="block text-gray-700 text-sm font-bold mb-2" for="password">Password:</label>
        <input v-model="formInfo.password" type="password" placeholder="Mot de passe" required
               class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
      </div>

      <div class="flex items-center justify-between">
        <button type="submit" class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline">
          {{ submitLabel }}
        </button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';

// Define props
const props = defineProps({
    formTitle: {
        type: String,
        required: true
    },
    submitLabel: {
        type: String,
        required: true
    }
});

// Define data
interface FormInfo {
    username?: string;
    email: string;
    password: string;
}

const formInfo: FormInfo = ref({
    username: '',
    email: '',
    password: '',
});

// Define methods
const emit = defineEmits();
const handleSubmit = () => {
    emit('form-submit', formInfo.value);
};
</script>
