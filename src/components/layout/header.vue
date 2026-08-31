<script setup lang="ts">
import { Search } from '@lucide/vue'
</script>

<template>
  <header
    class="sticky top-0 z-50 bg-surface/80 backdrop-blur-md border-b border-border-soft/30 shadow-[0px_10px_30px_rgba(27,42,65,0.05)] text-sm font-semibold tracking-wider"
  >
    <div class="flex justify-between items-center px-8 h-20 max-w-[1200px] mx-auto">
      <!-- Logo -->
      <a href="#" class="text-xl font-semibold tracking-tight text-primary"> 蟲生.蟲森 </a>

      <!-- 導覽選單（桌機才顯示） -->
      <nav class="hidden md:flex items-center gap-6">
        <a href="#" class="text-primary border-b-2 border-primary pb-1"> 首頁 </a>
        <a
          href="#"
          class="text-text-soft hover:text-primary hover:bg-card-low transition-colors duration-300 px-3 py-2 rounded"
        >
          飼育文章
        </a>
        <a
          href="#"
          class="text-text-soft hover:text-primary hover:bg-card-low transition-colors duration-300 px-3 py-2 rounded"
        >
          Bekuwa紀錄
        </a>
        <a
          href="#"
          class="text-text-soft hover:text-primary hover:bg-card-low transition-colors duration-300 px-3 py-2 rounded"
        >
          日常蟲事
        </a>
      </nav>

      <!-- 右側按鈕群 -->
      <div class="flex items-center gap-3">
        <button
          class="hidden md:block p-2 text-primary hover:bg-card-low rounded-full transition-colors"
        >
          <Search :size="20" />
        </button>
        <button
          class="bg-primary text-white px-4 py-2 rounded-lg hover:bg-secondary hover:shadow-md transition-all"
        >
          登入
        </button>
      </div>
    </div>
  </header>
</template>
