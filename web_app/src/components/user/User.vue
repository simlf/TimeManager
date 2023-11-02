<script setup lang="ts">
import {RouterView} from "vue-router";
import {useAuthStore} from "@/stores/auth.store";
import Login from "@/components/user/Login.vue";
import WorkingTimes from "../WorkingTimes.vue";

const authStore = useAuthStore();
</script>

<template>
    <div>
        <div v-if="!authStore.isAuthenticated">
            <!-- <RouterView></RouterView> -->
            <Login></Login>
        </div>
        <div v-else>
            <p>Welcome back {{ authStore.email }}</p>
            <WorkingTimes></WorkingTimes>
        </div>
    </div>
</template>

<style scoped>
</style>
