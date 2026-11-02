<script setup lang="ts">
import { Search } from '@lucide/vue';
</script>

<template>
  <header
    class="border-ink-200/30 bg-paper-500/80 sticky top-0 z-50 border-b text-sm font-semibold tracking-wider shadow-[0px_10px_30px_rgba(27,42,65,0.05)] backdrop-blur-md"
  >
    <div class="page-container flex h-20 items-center justify-between">
      <!-- Logo -->
      <a href="#" class="text-primary-500 text-xl font-semibold tracking-tight"> 蟲生.蟲森 </a>

      <!-- 導覽選單（桌機才顯示） -->
      <nav class="hidden items-center gap-6 md:flex">
        <a href="#" class="border-primary-500 text-primary-500 border-b-2 pb-1"> 首頁 </a>
        <a
          href="#"
          class="text-ink-400 hover:bg-paper-600 hover:text-primary-500 rounded px-3 py-2 transition-colors duration-300"
        >
          飼育文章
        </a>
        <a
          href="#"
          class="text-ink-400 hover:bg-paper-600 hover:text-primary-500 rounded px-3 py-2 transition-colors duration-300"
        >
          Bekuwa紀錄
        </a>
        <a
          href="#"
          class="text-ink-400 hover:bg-paper-600 hover:text-primary-500 rounded px-3 py-2 transition-colors duration-300"
        >
          日常蟲事
        </a>
      </nav>

      <!-- 右側按鈕群 -->
      <div class="flex items-center gap-3">
        <button
          class="text-primary-500 hover:bg-paper-600 hidden rounded-full p-2 transition-colors md:block"
        >
          <Search :size="20" />
        </button>
        <button
          class="bg-primary-500 hover:bg-secondary-600 rounded-lg px-4 py-2 text-white transition-all hover:shadow-md"
        >
          登入
        </button>
      </div>
    </div>
  </header>
</template>
