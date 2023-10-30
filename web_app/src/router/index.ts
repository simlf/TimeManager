import { createRouter, createWebHistory } from 'vue-router'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/chartManager',
      name: 'chartManager',
      component: () => import('../components/ChartManager.vue')
    }
    ,
    {
      path: '/clockManager/:username',
      name: 'clockManager',
      component: () => import('../components/ClockManager.vue')
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
    },
  ]
})

export default router
