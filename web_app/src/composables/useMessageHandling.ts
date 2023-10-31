import { computed } from 'vue';
import { useAuthStore } from "@/stores/auth.store";

export default function useMessageHandling() {
    const authStore = useAuthStore();
    const isError = (message: any) => {
        return message && message.error;
    };
    const isSuccess = (message: any) => {
        return message && message.success;
    };
    const clearError = () => {
        authStore.error = null;
    };
    const clearSuccess = () => {
        authStore.success = null;
    };

    const errorMessage = computed(() => {
        return isError(authStore.error) ? authStore.error.message : authStore.error;
    });

    const successMessage = computed(() => {
        return isSuccess(authStore.success) ? authStore.success.message : authStore.success;
    });

    return {
        isError,
        isSuccess,
        clearError,
        clearSuccess,
        errorMessage,
        successMessage
    };
}
