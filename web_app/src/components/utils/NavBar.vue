<template>
  <Disclosure as="nav" class="bg-white shadow" v-slot="{ open }">
    <div class="mx-auto max-w-7xl px-2 sm:px-6 md:px-7 lg:px-8">
      <div class="relative flex h-16 justify-between">
        <div class="absolute inset-y-0 left-0 flex items-center sm:hidden">
          <!-- Mobile menu button -->
          <DisclosureButton
            class="relative inline-flex items-center justify-center rounded-md p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
          >
            <span class="absolute -inset-0.5" />
            <span class="sr-only">Open main menu</span>
            <Bars3Icon v-if="!open" class="block h-6 w-6" aria-hidden="true" />
            <XMarkIcon v-else class="block h-6 w-6" aria-hidden="true" />
          </DisclosureButton>
        </div>
        <div class="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
          <div class="flex flex-shrink-0 items-center">
            <img
              class="h-8 w-auto"
              src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
              alt="Your Company"
            />
          </div>
          <div class="hidden sm:ml-6 sm:flex sm:space-x-8">
            <router-link
              :to="{ name: 'Home' }"
              exact
              class="inline-flex items-center px-1 pt-1 text-sm font-medium border-b-2"
              :class="getLinkClass($route.name === 'Home')"
            >
              Home
            </router-link>
            <router-link
              :to="{ name: 'chartManager' }"
              exact
              class="inline-flex items-center px-1 pt-1 text-sm font-medium border-b-2"
              :class="getLinkClass($route.name === 'chartManager')"
            >
              Chart Manager
            </router-link>
            <router-link
              :to="{ name: 'clockManager', params: { id: authStore.id } }"
              class="inline-flex items-center px-1 pt-1 text-sm font-medium border-b-2"
              :class="getLinkClass($route.name === 'clockManager')"
            >
              Clock Manager
            </router-link>
          </div>
        </div>
        <!-- If user is auth, display the avatar and the dropdown to view profile and signout -->
        <div
          v-if="authStore.isAuthenticated"
          class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0"
        >
          <button
            type="button"
            class="relative rounded-full bg-white p-1 text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            <span class="absolute -inset-1.5" />
            <span class="sr-only">View notifications</span>
            <BellIcon class="h-6 w-6" aria-hidden="true" />
          </button>

          <!-- Profile dropdown -->
          <Menu as="div" class="relative ml-3">
            <div>
              <MenuButton
                class="relative flex rounded-full bg-white text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                <span class="absolute -inset-1.5" />
                <span class="sr-only">Open user menu</span>
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke-width="1.5"
                  stroke="currentColor"
                  class="h-8 w-8 rounded-full"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M17.982 18.725A7.488 7.488 0 0012 15.75a7.488 7.488 0 00-5.982 2.975m11.963 0a9 9 0 10-11.963 0m11.963 0A8.966 8.966 0 0112 21a8.966 8.966 0 01-5.982-2.275M15 9.75a3 3 0 11-6 0 3 3 0 016 0z"
                  />
                </svg>
              </MenuButton>
            </div>
            <transition
              enter-active-class="transition ease-out duration-200"
              enter-from-class="transform opacity-0 scale-95"
              enter-to-class="transform opacity-100 scale-100"
              leave-active-class="transition ease-in duration-75"
              leave-from-class="transform opacity-100 scale-100"
              leave-to-class="transform opacity-0 scale-95"
            >
              <MenuItems
                class="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
              >
                <MenuItem as="router-link" v-slot="{ active }">
                  <router-link
                    to="/updateUser"
                    :class="[active ? 'bg-gray-100' : '', 'block px-4 py-2 text-sm text-gray-700']"
                    >Your Profile</router-link
                  >
                </MenuItem>
                <!-- TODO: Handle Signout -->
                <MenuItem as="router-link" v-slot="{ active }">
                  <router-link
                    to="/login"
                    :class="[active ? 'bg-gray-100' : '', 'block px-4 py-2 text-sm text-gray-700']"
                    >Sign out</router-link
                  >
                </MenuItem>
              </MenuItems>
            </transition>
          </Menu>
        </div>
        <!-- If user is not auth, display a login button -->
        <div
          v-else
          class="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0"
        >
          <button
            as="router-link"
            type="button"
            class="rounded-md bg-indigo-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
          >
            <router-link to="/login">Login</router-link>
          </button>
        </div>
      </div>
    </div>
    <DisclosurePanel class="sm:hidden">
      <div class="space-y-1 pb-4 pt-2">
        <router-link :to="{ name: 'Home' }">
          <DisclosureButton
            as="a"
            class="block py-2 pl-3 pr-4 text-base font-medium border-l-4"
            :class="getLinkClass($route.name === 'Home')"
          >
            Home
          </DisclosureButton>
        </router-link>
        <router-link :to="{ name: 'chartManager' }">
          <DisclosureButton
            as="a"
            class="block py-2 pl-3 pr-4 text-base font-medium border-l-4"
            :class="getLinkClass($route.name === 'chartManager')"
          >
            Chart Manager
          </DisclosureButton>
        </router-link>
        <router-link :to="{ name: 'clockManager', params: { id: authStore.id } }">
          <DisclosureButton
            as="a"
            class="block py-2 pl-3 pr-4 text-base font-medium border-l-4"
            :class="getLinkClass($route.name === 'clockManager')"
          >
            Clock Manager
          </DisclosureButton>
        </router-link>
      </div>
    </DisclosurePanel>
  </Disclosure>
</template>

<script setup lang="ts">
import {
  Disclosure,
  DisclosureButton,
  DisclosurePanel,
  Menu,
  MenuButton,
  MenuItem,
  MenuItems
} from '@headlessui/vue'
import { Bars3Icon, BellIcon, XMarkIcon } from '@heroicons/vue/24/outline'
import { useAuthStore } from '@/stores/auth.store'
import { onMounted } from 'vue'

const authStore = useAuthStore()

onMounted(async () => {
  await authStore.checkAuth()
})

const getLinkClass = (isActive) => {
  if (isActive) {
    return 'border-indigo-500 text-gray-900'
  } else {
    return 'text-gray-500 border-transparent hover:border-gray-300 hover:text-gray-700'
  }
}
</script>
