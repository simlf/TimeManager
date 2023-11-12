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
      name: 'ProfilePage',
      meta: { requiresAuth: true },
      component: () => import('@/views/users/ProfileView.vue')
    },
    {
      path: '/clockManager/:username',
      name: 'ClockManagerPage',
      meta: { requiresAuth: true },
      component: () => import('@/views/ClockManagerView.vue')
    },
    {
      path: '/workingTimes/:userId?',
      name: 'WorkingTimesPage',
      meta: { requiresAuth: true },
      component: () => import('@/views/workingTimes/WorkingTimesView.vue')
    },
    {
      path: '/workingTimesManager/:groupId?',
      name: 'WorkingTimesManagerPage',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      component: () => import('@/views/workingTimes/WorkingTimesManagerView.vue')
    },
    {
      path: '/workingTimesSuperManager/',
      name: 'WorkingTimesSuperManagerPage',
      meta: { requiresAuth: true, requiresSuperManager: true },
      component: () => import('@/views/workingTimes/WorkingTimesSuperManagerView.vue')
    },
    {
      path: '/workingTimesEditor/',
      name: 'WorkingTimesEditorPage',
      meta: { requiresAuth: true, requiresSuperManager: true },
      component: () => import('@/views/workingTimes/WorkingTimesEditorView.vue')
    },
    {
      path: '/groups',
      name: 'GroupsListPage',
      meta: { requiresAuth: true, requiresSuperManager: true },
      component: () => import('@/views/groups/GroupsListView.vue')
    },
    {
      path: '/groups/create',
      name: 'CreateGroupPage',
      meta: { requiresAuth: true, requiresSuperManager: true },
      component: () => import('@/views/groups/GroupCreateView.vue')
    },
    {
      path: '/groups/update/:id',
      name: 'UpdateGroupPage',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      component: () => import('@/views/groups/GroupUpdateView.vue')
    },
    {
      path: '/groups/show/:id',
      name: 'ShowGroupPage',
      meta: { requiresAuth: true, requiresManagerOrSuperManager: true },
      component: () => import('@/views/groups/GroupShowOneView.vue')
    },
    {
      path: '/users',
      name: 'UsersListPage',
      meta: { requiresAuth: true, requiresSuperManager: true },
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
      name: 'NotFound',
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
    next({ name: 'LoginPage' })
  } else if (requiresManagerOrSuperManager) {
    // Check if user is a manager or super_manager
    if (authStore.isSuperManager || authStore.isManager) {
      next() // Proceed as normal for managers and super_managers
    } else {
      // Redirect non-managers to Home or a 'NotAuthorized' page
      next({ name: 'HomePage' })
    }
  } else if (requiresSuperManager && !authStore.isSuperManager) {
    // Redirect non-super_managers to Home or a 'NotAuthorized' page
    next({ name: 'HomePage' })
  } else if (requiresManager && !authStore.isSuperManager && !authStore.isManager) {
    // Redirect non-managers to Home or a 'NotAuthorized' page
    next({ name: 'HomePage' })
  } else {
    // No special requirements, proceed as normal
    next()
  }
})

export default router
