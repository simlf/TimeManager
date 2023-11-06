<template>
  <div class="bg-white">
    <main>
      <!-- Hero section -->
      <div class="relative isolate overflow-hidden bg-gray-900 pb-16 pt-14 sm:pb-20">
        <img
          src="https://images.unsplash.com/photo-1521737604893-d14cc237f11d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2830&q=80&blend=111827&sat=-100&exp=15&blend-mode=multiply"
          alt="Background Image for landing page"
          class="absolute inset-0 -z-10 h-full w-full object-cover"
        />
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
            <div class="text-center">
              <h1 class="text-4xl font-bold tracking-tight text-white sm:text-6xl">
                Master Your Gotham Work Hours
              </h1>
              <p class="mt-6 text-lg leading-8 text-gray-300">
                Effortlessly track, manage, and analyze your work hours with Gotham Time Tracker.
                Take control of your time today!
              </p>
              <div class="mt-10 flex items-center justify-center gap-x-6">
                <router-link
                  to="/register"
                  class="rounded-md bg-indigo-500 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-400"
                  >Get started</router-link
                >
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Feature section -->
      <div class="mt-32 sm:mt-56">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="mx-auto max-w-2xl sm:text-center">
            <h2 class="text-base font-semibold leading-7 text-indigo-600">Optimize Your Time</h2>
            <p class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
              Smart tracking at your fingertips
            </p>
            <p class="mt-6 text-lg leading-8 text-gray-600">
              Gotham Time Tracker is designed to simplify your workday, providing insights and
              analytics to boost productivity.
            </p>
          </div>
        </div>
        <div class="relative overflow-hidden pt-16">
          <div class="mx-auto max-w-7xl px-6 lg:px-8">
            <img
              src="appExample.png"
              alt="App screenshot"
              class="mb-[-12%] rounded-xl shadow-2xl ring-1 ring-gray-900/10"
            />
          </div>
        </div>
      </div>

      <!-- Testimonial section -->
      <div class="relative z-10 mt-32 bg-gray-900 pb-20 sm:mt-56 sm:pb-24 xl:pb-0">
        <div
          class="mx-auto flex max-w-7xl flex-col items-center gap-x-8 gap-y-10 px-6 sm:gap-y-8 lg:px-8 xl:flex-row xl:items-stretch"
        >
          <div class="w-full max-w-2xl xl:max-w-none xl:flex-auto xl:px-16 xl:py-24">
            <figure class="relative isolate pt-6 sm:pt-12">
              <blockquote class="text-xl font-semibold leading-8 text-white sm:text-2xl">
                <p>
                  "Gotham Time Tracker has revolutionized the way we manage our work hours. It's
                  intuitive, efficient, and gives us the data we need to make informed decisions
                  about our time management."
                </p>
              </blockquote>
              <figcaption class="mt-6 flex items-center gap-x-4">
                <img src="brucewayne.jpg" alt="Bruce Wayne" class="h-12 w-12 rounded-full" />
                <div class="text-sm font-medium text-gray-300">
                  <div>Bruce Wayne</div>
                  <div class="mt-1">CEO, Wayne Enterprises</div>
                </div>
              </figcaption>
            </figure>
          </div>
        </div>
      </div>
    </main>

    <!-- Footer -->
    <footer class="bg-gray-900">
      <div class="mx-auto max-w-7xl px-6 lg:px-8">
        <div class="py-12 flex flex-col items-center gap-y-4 sm:flex-row sm:justify-between">
          <div class="text-sm text-gray-300">
            &copy; 2023 Gotham Time Tracker. All rights reserved.
          </div>
          <div class="flex gap-x-6">
            <a href="#" class="text-sm text-gray-300 hover:text-gray-100">Privacy Policy</a>
            <a href="#" class="text-sm text-gray-300 hover:text-gray-100">Terms of Service</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>
