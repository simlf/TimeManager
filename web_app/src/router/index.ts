import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ClockManagerView from '../views/ClockManager.vue'
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
      path: '/clockManager',
      name: 'clockManager',
      component: ClockManagerView
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
