import { defineStore } from 'pinia';
import axios from 'axios';
import type { AxiosResponse } from 'axios';
import router from "@/router";

const API_BASE_URL = 'http://localhost:4000/api/users';

interface LoginPayload {
    user: {
        username?: string;
        email: string;
        password: string;
    };
}

export const useAuthStore = defineStore({
    id: 'auth',
    state: () => ({
        user: null as { email: string; password: string } | null,
        isAuthenticated: false,
        error: null as Error | null,
        returnUrl: null,
    }),
    actions: {
        async checkAuth(): Promise<boolean> {
            try {
                await axios.get(`${API_BASE_URL}/check_auth`)
                this.isAuthenticated = true
                console.log("Authenticated")
                return true
            } catch (error: Error | any) {
                this.isAuthenticated = false
                this.user = null
                this.error = new Error(`You are not authenticated, ${error.response?.status}`)
                return false
            }
        },
        async register(credentials: { username: string, email: string; password: string }) {
            this.error = null;

            const payload: LoginPayload = {
                user: {
                    username: credentials.username,
                    email: credentials.email,
                    password: credentials.password,
                },
            };
            try {
                await axios.post(`${API_BASE_URL}/`, payload)

                // Redirect to the returnUrl or a default route
                const redirectUrl = this.returnUrl || '/login';
                this.returnUrl = null; // Clear returnUrl after redirecting
                router.push(redirectUrl);
            } catch (error: Error | any) {
                this.error = new Error(`HTTP Error ${error.response?.status}`)
                this.error.message = "Error registering user"
            }
        },
        async login(credentials: { email: string; password: string }) {
            this.error = null;

            const payload: LoginPayload = {
                user: {
                    email: credentials.email,
                    password: credentials.password,
                },
            };

            try {
                const response = await axios.post(`${API_BASE_URL}/log_in`, payload)

                this.user = credentials;
                this.isAuthenticated = true;
                // Redirect to the returnUrl or a default route
                const redirectUrl = this.returnUrl || '/chartManager'
                this.returnUrl = null // Clear returnUrl after redirecting
                router.push(redirectUrl)
            } catch (error: Error | any) {
                this.error = new Error(`Unfortunately an error occurred, make sure your credentials are good ${error.response?.status}`)
            }
        },
        logout() {
            this.user = null;
            this.error = null;
        },
    },
});
