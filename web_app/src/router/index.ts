import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth.store'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'HomePage',
      component: () => import('@/views/HomeView.vue')
    },
    {
      path: '/login',
      name: 'LoginPage',
      component: () => import('@/views/LoginView.vue')
    },
    {
      path: '/profile',
      meta: { requiresAuth: true },
      name: 'ProfilePage',
      component: () => import('@/views/users/ProfileView.vue')
    },
    {
      path: '/clockManager/:username',
      name: 'clockManagerPage',
      meta: { requiresAuth: true },
      component: () => import('@/views/ClockManagerView.vue')
    },
    {
      path: '/workingTimes/:userId?',
      name: 'workingTimesPage',
      meta: { requiresAuth: true },
      component: () => import('@/views/workingTimes/WorkingTimesView.vue')
    },
    {
      path: '/workingTimesUser/:userId',
      name: 'workingTimesUserPage',
      meta: { requiresAuth: true },
      component: () => import('@/views/workingTimes/WorkingTimesUserView.vue')
    },
    {
      path: '/workingTimesManager',
      name: 'workingTimesManagerPage',
      meta: {requiresAuth: true},
      component: () => import('@/views/workingTimes/WorkingTimesManagerView.vue')
    },
    {
      path: '/groups',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'GroupsListPage',
      component: () => import('@/views/groups/GroupsListView.vue')
    },
    {
      path: '/groups/create',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'CreateGroupPage',
      component: () => import('@/views/groups/GroupCreateView.vue')
    },
    {
      path: '/group/update/:id',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      name: 'UpdateGroupPage',
      component: () => import('@/views/groups/GroupUpdateView.vue')
    },
    {
      path: '/group/show/:id',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      name: 'ShowGroupPage',
      component: () => import('@/views/groups/GroupShowOneView.vue')
    },
    {
      path: '/users',
      meta: { requiresAuth: true, requiresSuperManager: true },
      name: 'UsersListPage',
      component: () => import('@/views/users/UsersListView.vue')
    },
    {
      path: '/users/create/:groupId?',
      name: 'CreateUserPage',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      component: () => import('@/views/users/CreateUserView.vue')
    },
    {
      path: '/:pathMatch(.*)*',
      name: 'Not Found',
      component: () => import('@/views/NotFoundView.vue')
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
