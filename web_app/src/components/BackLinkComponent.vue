<template>
  <button
    type="button"
    @click="router.go(-1)"
    class="font-semibold leading-6 text-indigo-600 hover:text-indigo-500"
  >
    Go Back
  </button>
</template>
<script setup lang="ts">
import router from '@/router'
</script>
