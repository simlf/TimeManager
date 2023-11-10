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
      path: '/login',
      name: 'Login',
      component: () => import('@/components/user/Login.vue')
    },
    {
      path: '/clockManager/:username',
      name: 'clockManager',
      meta: { requiresAuth: true },
      component: () => import('../components/ClockManager.vue')
    },
    {
      path: '/workingTimes/:userId?',
      name: 'workingTimes',
      meta: { requiresAuth: true },
      component: () => import('../components/WorkingTimes.vue')
    },
    {
      path: '/workingTimesUser/:userId',
      name: 'workingTimesUser',
      meta: { requiresAuth: true },
      component: () => import('../components/WorkingTimesUser.vue')
    },
    {
      path: '/workingTimesManager',
      name: 'workingTimesManager',
      meta: { requiresAuth: true },
      component: () => import('../components/WorkingTimesManager.vue')
    },
    {
      path: '/updateUser',
      meta: { requiresAuth: true },
      name: 'UpdateUser',
      component: () => import('@/components/user/UpdateUser.vue')
    },
    {
      path: '/createUser/:groupId?',
      name: 'CreateUser',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      component: () => import('@/components/user/Register.vue')
    },
    {
      path: '/users',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'UsersList',
      component: () => import('@/components/user/UsersList.vue')
    },
    {
      path: '/groups',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'GroupsList',
      component: () => import('@/components/group/GroupsList.vue')
    },
    {
      path: '/group/create',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'CreateGroup',
      component: () => import('@/components/group/GroupCreate.vue')
    },
    {
      path: '/group/update/:id',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      name: 'UpdateGroup',
      component: () => import('@/components/group/GroupUpdate.vue')
    },
    {
      path: '/group/show/:id',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      name: 'ShowGroup',
      component: () => import('@/components/group/GroupShowOne.vue')
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
  const requiresManagerOrSuperManager = to.meta.requiresManagerOrSuperManager
  const requiresSuperManager = to.meta.requiresSuperManager
  const authStore = useAuthStore()

  const isAuthenticated = await authStore.checkAuth()

  if (requiresAuth && !isAuthenticated) {
    // Redirect unauthenticated users to the Login page
    next({ name: 'Login' })
  } else if (requiresManagerOrSuperManager) {
    // Check if user is a manager or super_manager
    if (authStore.isSuperManager || authStore.isManager) {
      next() // Proceed as normal for managers and super_managers
    } else {
      // Redirect non-managers to Home or a 'NotAuthorized' page
      next({ name: 'Home' })
    }
  } else if (requiresSuperManager && !authStore.isSuperManager) {
    // Redirect non-super_managers to Home or a 'NotAuthorized' page
    next({ name: 'Home' })
  } else if (requiresManager && !authStore.isSuperManager && !authStore.isManager) {
    // Redirect non-managers to Home or a 'NotAuthorized' page
    next({ name: 'Home' })
  } else {
    // No special requirements, proceed as normal
    next()
  }
})

export default router
