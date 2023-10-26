<template>
  <div>
    <button v-if="!showLoginForm" @click="showLoginForm = true">Login</button>

    <div v-if="showLoginForm">
      <UserForm formTitle="Login Form" submitLabel="Login" @form-submit="handleLogin" />
      <p>Don't have an account ?</p>
      <RouterLink to="/register">Register</RouterLink>
    </div>
    <RouterView></RouterView>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import UserForm from './UserForm.vue';

export default defineComponent({
  components: {
    UserForm
  },
  data() {
    return {
      showLoginForm: false,
    };
  },
  methods: {
    handleLogin(data: { email: string; password: string }) {
      // TODO: Perform login logic with API
      console.log('Login:', data);
      // Redirect to root page
      this.$router.push('/');
    },
  },
});
</script>

<style scoped>
</style>
