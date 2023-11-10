import { defineStore } from 'pinia'
import axios from 'axios'
import router from '@/router'

const API_BASE_URL = 'http://localhost:4000/api/users'

interface LoginPayload {
  user: {
    username?: string
    email?: string
    password?: string
  }
}

interface User {
  id: number
  username: string
  email: string
  role: string
}

const createPayload = (user: {
  username?: string
  email?: string
  password?: string
  role?: 'EMPLOYEE' | 'MANAGER'
  group_id?: number | null
}): LoginPayload => ({
  user: user
})

export const useAuthStore = defineStore({
  id: 'auth',
  state: () => ({
    user: null as User | null,
    isAuthenticated: false,
    error: null as Error | null,
    success: null as string | null,
    returnUrl: null
  }),
  getters: {
    username: (state) => state.user?.username || 'null',
    email: (state) => state.user?.email || '',
    id: (state) => state.user?.id || -1,
    isSuperManager: (state) => state.user?.role === 'SUPER_MANAGER',
    isManager: (state) => state.user?.role === 'MANAGER',
    isEmployee: (state) => state.user?.role === 'EMPLOYEE'
  },
  actions: {
    async checkAuth(): Promise<boolean> {
      try {
        const response = await axios.get(`${API_BASE_URL}/check_auth`)
        this.isAuthenticated = true
        this.user = response.data.data
        return true
      } catch (error: Error | any) {
        this.isAuthenticated = false
        this.user = null
        this.handleError(error, 'Make sure you are logged in')
        return false
      }
    },
    async register(credentials: {
      username: string
      email: string
      password: string
      role?: 'EMPLOYEE' | 'MANAGER'
      group_id?: number
    }) {
      this.error = null
      const payload = createPayload({
        username: credentials.username,
        email: credentials.email,
        password: credentials.password,
        role: credentials.role ?? 'EMPLOYEE',
        group_id: credentials.group_id ?? null
      })

      try {
        await axios.post(`${API_BASE_URL}/`, payload)
        this.success = 'User registered successfully'
      } catch (error: Error | any) {
        this.handleError(
          error,
          'Error registering user, your password should be at least 6 characters long and the email should be less than 20 characters long'
        )
      }
    },
    async login(credentials: { email: string; password: string }) {
      this.error = null
      const payload = createPayload({
        email: credentials.email,
        password: credentials.password
      })

      try {
        await axios.post(`${API_BASE_URL}/log_in`, payload)
        this.isAuthenticated = true
        this.success = 'User logged in  successfully'
        this.redirectTo('/')
      } catch (error: Error | any) {
        this.handleError(error, 'Error logging in, make sure your credentials are good')
      }
    },
    async updateUser(credentials: { id: number; username: string; email: string }) {
      this.error = null
      this.success = null
      const payload = createPayload({
        username: credentials.username,
        email: credentials.email
      })
      try {
        const response = await axios.put(`${API_BASE_URL}/me`, payload)

        this.user = response.data.data
        this.isAuthenticated = true
        this.success = 'User updated successfully'
      } catch (error: Error | any) {
        this.handleError(error, 'Make sure the email is valid')
      }
    },
    async updateUserPassword(credentials: { id: number; password: string }) {
      this.error = null
      this.success = null
      const payload = createPayload({
        password: credentials.password
      })
      try {
        const response = await axios.put(`${API_BASE_URL}/update_password/${this.id}`, payload)

        this.user = response.data.data
        this.isAuthenticated = true
        this.success = 'Password updated successfully'
      } catch (error: Error | any) {
        this.handleError(error, 'Error updating user password')
      }
    },
    async logout() {
      this.user = null
      this.error = null
      this.isAuthenticated = false
      await axios.get(`${API_BASE_URL}/log_out`)
      this.redirectTo('/')
    },
    redirectTo(route: string) {
      const redirectUrl = this.returnUrl || route
      this.returnUrl = null
      router.push(redirectUrl)
    },
    handleError(error: Error | any, defaultMessage: string): void {
      let errorMessage = defaultMessage

      if (error && error.response && error.response.status) {
        errorMessage += ` (HTTP ${error.response.status})`
      }
      this.error = new Error(errorMessage)
    }
  }
})
