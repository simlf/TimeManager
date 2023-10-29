import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/chartManager',
      name: 'chartManager',
      component: () => import('../components/ChartManager.vue')
    },
    {
      path: '/login',
      name: 'login',
      component: () => import('../components/user/Login.vue')
    },
    {
      path: '/register',
      name: 'register',
      component: () => import('../components/user/Register.vue')
    },{
      path: '/workedTimes',
      name: 'workedTimes',
      component: () => import('../components/WorkedTimes.vue')
    },
  ]
})

export default router
