<script lang="ts">
import { defineComponent } from 'vue';
import Login from './Login.vue';

export default defineComponent({
  data() {
    return {
      isLoggedIn: false,
    };
  },
});
</script>

<template>
  <div>
    <div v-if="!isLoggedIn">
        <Login></Login>
        <p>Not logged in</p>
    </div>
    <div v-else>
        <p>Logged in</p>
    </div>
</div>
</template>

<style scoped>
</style>
