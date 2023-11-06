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

const createPayload = (user: {
  username?: string
  email?: string
  password?: string
}): LoginPayload => ({
  user: user
})

export const useAuthStore = defineStore({
  id: 'auth',
  state: () => ({
    user: null as { id?: number; username?: string; email: string } | null,
    isAuthenticated: false,
    error: null as Error | null,
    success: null as string | null,
    returnUrl: null,

  }),
  getters: {
    username: (state) => state.user?.username || '',
    email: (state) => state.user?.email || '',
    id: (state) => state.user?.id || -1
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
    async register(credentials: { username: string; email: string; password: string }) {
      this.error = null
      const payload = createPayload({
        username: credentials.username,
        email: credentials.email,
        password: credentials.password
      })

      try {
        await axios.post(`${API_BASE_URL}/`, payload)
        this.showSuccessMessage("User registered successfully")
        this.redirectTo('/login')
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
        this.user = credentials
        this.isAuthenticated = true
        // this.saveToLocalStorage()
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
        const response = await axios.put(`${API_BASE_URL}/${this.id}`, payload)

        this.user = response.data.data
        this.isAuthenticated = true
        this.showSuccessMessage('Password updated successfully')
        // this.success = 'User updated successfully'
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
        this.showSuccessMessage('Password updated successfully')
        // this.success = 'Password updated successfully'
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
      // setTimeout(() => {
      //   this.clearSuccessMessage();
      // }, 10000); // Efface le message après 10 secondes
    },
    showSuccessMessage(message: string) {
      this.success = message;
      // setTimeout(() => {
      //   this.clearSuccessMessage();
      // }, 10000); // Efface le message après 10 secondes 
    },
    clearSuccessMessage() {
      this.success = null;
      this.error = null;
    },

  }
})
