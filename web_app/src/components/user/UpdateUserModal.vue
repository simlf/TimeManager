<template>
  <TransitionRoot as="template" :show="isUpdateUserModalOpen">
    <Dialog as="div" class="relative z-10" @click.stop="closeModal">
      <TransitionChild
        as="template"
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" />
      </TransitionChild>

      <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
        <div
          class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0"
        >
          <TransitionChild
            as="template"
            enter="ease-out duration-300"
            enter-from="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            enter-to="opacity-100 translate-y-0 sm:scale-100"
            leave="ease-in duration-200"
            leave-from="opacity-100 translate-y-0 sm:scale-100"
            leave-to="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          >
            <DialogPanel
              class="relative transform overflow-hidden rounded-lg bg-white px-4 pb-4 pt-5 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg sm:p-6"
            >
              <div>
                <div
                  class="mx-auto flex h-12 w-12 items-center justify-center rounded-full bg-green-100"
                >
                  <UsersIcon class="h-6 w-6 text-green-600" aria-hidden="true" />
                </div>
                <div class="mt-3 text-center sm:mt-5">
                  <form @submit.prevent="updateProfile" class="mt-5 flex flex-col items-center">
                    <div class="w-full sm:max-w-xs">
                      <label
                        for="username"
                        class="block text-sm font-medium leading-6 text-gray-600"
                        >Username</label
                      >
                      <input
                        type="text"
                        name="username"
                        v-model="username"
                        class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                        placeholder="Username"
                      />
                    </div>
                    <div class="w-full sm:max-w-xs">
                      <label for="email" class="block text-sm font-medium leading-6 text-gray-600"
                        >Email</label
                      >
                      <input
                        type="email"
                        name="email"
                        v-model="email"
                        class="block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                        placeholder="Email"
                      />
                    </div>
                    <div v-if="authStore.isSuperManager" class="w-full sm:max-w-xs">
                      <label class="typo__label">Role</label>
                      <multiselect
                        v-if="roles"
                        v-model="role"
                        :options="roles"
                        :searchable="false"
                        :close-on-select="true"
                        :show-labels="true"
                        placeholder="Pick a value"
                      ></multiselect>
                    </div>
                  </form>
                </div>
              </div>
              <div class="mt-5 sm:mt-6 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
                <button
                  type="button"
                  class="inline-flex w-full justify-center rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600 sm:col-start-2"
                  @click="updateUser"
                >
                  Save
                </button>
                <button
                  type="button"
                  class="mt-3 inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50 sm:col-start-1 sm:mt-0"
                  @click="closeModal"
                  ref="cancelButtonRef"
                >
                  Cancel
                </button>
              </div>
            </DialogPanel>
          </TransitionChild>
        </div>
      </div>
    </Dialog>
  </TransitionRoot>
</template>

<script setup>
import { ref, watch } from 'vue'
import { Dialog, DialogPanel, TransitionChild, TransitionRoot } from '@headlessui/vue'
import { UsersIcon } from '@heroicons/vue/24/outline'
import Multiselect from 'vue-multiselect'
import { useAuthStore } from '@/stores/auth.store'
import axios from 'axios'

const authStore = useAuthStore()
const roles = ['EMPLOYEE', 'MANAGER']

const props = defineProps({
  isUpdateUserModalOpen: Boolean,
  initialUsername: String,
  initialEmail: String,
  initialRole: String,
  initialGroupId: Number,
  userId: Number
})

const emit = defineEmits(['update:isUpdateUserModalOpen'])

const username = ref('')
const email = ref('')
const role = ref('')

watch(
  () => props.isUpdateUserModalOpen,
  (newValue) => {
    if (newValue) {
      username.value = props.initialUsername
      email.value = props.initialEmail
      role.value = props.initialRole
    }
  },
  { immediate: true }
)

function closeModal() {
  emit('update:isUpdateUserModalOpen', false)
}

const updateUser = async () => {
  try {
    const data = {
      user: {
        username: username.value,
        email: email.value,
        role: role.value,
        group_id: props.initialGroupId
      }
    }
    const updateUser = await axios.put('http://localhost:4000/api/users/' + props.userId, data)
    if (updateUser.status === 200) {
      emit('update:isUpdateUserModalOpen', false)
    }
  } catch (e) {
    console.log('Something wrong happens during update')
  }
}
</script>
