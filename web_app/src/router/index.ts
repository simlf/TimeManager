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
      path: '/clockManager/:username',
      name: 'clockManager',
      meta: { requiresAuth: true },
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
      path: '/workingTimes/:userId',
      name: 'workingTimes',
      meta: { requiresAuth: true },
      component: () => import('../components/WorkingTimes.vue')
    },
    {
      path: '/updateUser',
      meta: { requiresAuth: true },
      name: 'UpdateUser',
      component: () => import('@/components/user/UpdateUser.vue')
    },
    {
      path: '/updateGroup',
      meta: { requiresAuth: true, requiresManager: true },
      name: 'UpdateGroup',
      component: () => import('@/components/group/UpdateGroup.vue')
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
  const requiresManager = to.meta.requiresManager
  const authStore = useAuthStore()

  const isAuthenticated = await authStore.checkAuth()

  if (requiresAuth && !isAuthenticated) {
    // Redirect unauthenticated users to the Login page
    next({ name: 'Login' })
  } else if (requiresManager && !authStore.isSuperManager && !authStore.isManager) {
    // Redirect non-managers or unauthenticated users to a 'NotAuthorized' or similar page
    next({ name: 'Home' }) // Make sure you have defined a route with the name 'NotAuthorized'
  } else {
    // No special requirements, proceed as normal
    next()
  }
})

export default router
