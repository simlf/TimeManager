<template>
  <div>
    <SideBar></SideBar>
    <div class="content">
      <slot></slot>
    </div>
  </div>
</template>

<script setup lang="ts">
import SideBar from '@/components/utils/NavBar.vue'
</script>
