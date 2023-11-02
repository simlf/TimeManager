import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('@/components/utils/Home.vue')
    },
    {
      path: '/chartManager',
      name: 'chartManager',
      meta: { requiresAuth: true },
      component: () => import('@/components/ChartManager.vue')
    },
    {
      path: '/clockManager/:username',
      name: 'clockManager',
      component: () => import('../components/ClockManager.vue')
    },
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/components/user/Login.vue')
    },
    {
      path: '/register',
      name: 'Register',
      component: () => import('@/components/user/Register.vue')
    },
    {
      path: '/workingTimes',
      meta: { requiresAuth: true },
      name: 'workingTimes',
      component: () => import('../components/WorkingTimes.vue')
    },
    {
      path: '/updateUser',
      meta: { requiresAuth: true },
      name: 'UpdateUser',
      component: () => import('@/components/user/UpdateUser.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'Not Found',
      component: () => import('@/components/utils/PageNotFound.vue')
    }
  ]
})

router.beforeEach(async (to, from, next) => {
  const requiresAuth = to.meta.requiresAuth
  const authStore = useAuthStore()

  if (requiresAuth) {
    const isAuthenticated = await authStore.checkAuth()
    if (isAuthenticated) {
      next()
    } else {
      next({ name: 'Login' })
    }
  } else {
    next()
  }
})

export default router
