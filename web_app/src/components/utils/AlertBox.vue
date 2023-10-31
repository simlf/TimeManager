<template>
    <div :class="['rounded-md p-4', backgroundColor]">
        <div class="flex">
            <div class="flex-shrink-0">
                <component :is="iconComponent" class="h-5 w-5" :class="iconColor" aria-hidden="true" />
            </div>
            <div class="ml-3">
                <p class="text-sm font-medium" :class="textColor">{{ message }}</p>
            </div>
            <div class="ml-auto pl-3">
                <div class="-mx-1.5 -my-1.5">
                    <button @click="dismiss" type="button" class="inline-flex rounded-md p-1.5 focus:outline-none focus:ring-2 focus:ring-offset-2" :class="[backgroundColor, hoverColor, focusRingColor]">
                        <span class="sr-only">Dismiss</span>
                        <XMarkIcon class="h-5 w-5" aria-hidden="true" />
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { defineProps, defineEmits } from 'vue';
import { CheckCircleIcon, XMarkIcon, ExclamationCircleIcon } from '@heroicons/vue/20/solid';

const { type, message } = defineProps(['type', 'message']);
const emit = defineEmits();

const dismiss = () => {
    emit('dismiss');
};

const iconComponent = type === 'success' ? CheckCircleIcon : ExclamationCircleIcon;
const backgroundColor = type === 'success' ? 'bg-green-50' : 'bg-red-50';
const iconColor = type === 'success' ? 'text-green-400' : 'text-red-400';
const textColor = type === 'success' ? 'text-green-800' : 'text-red-800';
const hoverColor = type === 'success' ? 'hover:bg-green-100' : 'hover:bg-red-100';
const focusRingColor = type === 'success' ? 'focus:ring-green-600 focus:ring-offset-green-50' : 'focus:ring-red-600 focus:ring-offset-red-50';
</script>
