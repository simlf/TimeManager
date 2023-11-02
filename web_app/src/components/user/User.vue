<script setup lang="ts">
import { RouterView } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'

const authStore = useAuthStore()
</script>

<template>
  <div>
    <div v-if="!authStore.isAuthenticated">
      <RouterView></RouterView>
    </div>
    <div v-else>
      <p>Welcome back {{ authStore.email }}</p>
    </div>
  </div>
</template>

<style scoped></style>
