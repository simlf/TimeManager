<template>
  <div>
    <h1>Welcome to My Home Page!</h1>
    <p>This is the content of the home page.</p>
  </div>
</template>

<script>
import { useAuthStore } from '@/stores/auth.store'
import { useRouter } from 'vue-router'
import { onMounted } from 'vue'

// to complete
export default {
  name: 'Home',
  // setup() {
  //   const router = useRouter()
  //   const authStore = useAuthStore()

  //   onMounted(async () => {
  //     await authStore.checkAuth()

  //     if (!authStore.isAuthenticated) {
  //       router.push('/login')
  //     }
  //   })
  // }
}
</script>
