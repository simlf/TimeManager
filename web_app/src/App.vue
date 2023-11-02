<template>
    <div id="app">
        <Layout/>
        <router-view/>
    </div>
</template>

<script lang="ts">
import Layout from '@/components/utils/Layout.vue';

export default {
    components: {
        Layout
    }
};
</script>
