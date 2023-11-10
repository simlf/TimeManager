import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth.store'

// Définissez un type pour les objets de message
interface MessageObject {
  message: string
  // Vous pouvez ajouter d'autres propriétés ici si nécessaire
}

export default function useMessageHandling() {
  const authStore = useAuthStore()

  const isError = (message: any): message is MessageObject => {
    return message && (message as MessageObject).message !== undefined
  }

  const isSuccess = (message: any): message is MessageObject => {
    return message && (message as MessageObject).message !== undefined
  }

  const clearError = () => {
    authStore.error = null
  }

  const clearSuccess = () => {
    authStore.success = null
  }

  const errorMessage = computed(() => {
    // Utilisez l'opérateur d'option facultative pour accéder à la propriété 'message'
    return isError(authStore.error) ? authStore.error?.message : authStore.error
  })

  const successMessage = computed(() => {
    // Utilisez l'opérateur d'option facultative pour accéder à la propriété 'message'
    return isSuccess(authStore.success) ? authStore.success?.message : authStore.success
  })

  return {
    isError,
    isSuccess,
    clearError,
    clearSuccess,
    errorMessage,
    successMessage
  }
}
