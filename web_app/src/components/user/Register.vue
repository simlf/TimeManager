<template>
  <div>
    <div>
      <UserForm formTitle="Register Form" submitLabel="Register" @form-submit="createUser" />
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import UserForm from './UserForm.vue';

export default defineComponent({
  components: {
    UserForm
  },
  methods: {
    createUser(data: { email: string; password: string }) {
      // TODO: Perform register logic with API
      console.log('Register:', data);
      // Redirect to root page
      this.$router.push('/');
    },
  },
});
</script>

<style scoped>
</style>
