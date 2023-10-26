<template>
  <div>
    <div class="max-w-md mx-auto">
      <form @submit.prevent="handleSubmit" class="bg-white shadow-md rounded px-8 pt-6 pb-8 mb-4">
        <h2 class="text-2xl mb-6 text-green-500">{{ formTitle }}</h2>

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
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

interface FormInfo {
  email: string;
  password: string;
}

export default defineComponent({
  props: {
    formTitle: {
      type: String,
      required: true
    },
    submitLabel: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      formInfo: {
        email: '',
        password: ''
      } as FormInfo
    };
  },
  methods: {
    handleSubmit() {
      this.$emit('form-submit', this.formInfo);
    }
  }
});
</script>
