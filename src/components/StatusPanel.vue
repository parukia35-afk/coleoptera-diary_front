<script setup>
import { CircleAlert, LoaderCircle } from '@lucide/vue';

defineProps({
  message: { type: String, required: true },
  // true = 失敗畫面,false(預設)= 載入中畫面
  isError: { type: Boolean, default: false },
});
</script>

<template>
  <section class="py-12 md:py-16">
    <div class="page-container">
      <!-- role:讓螢幕閱讀器念出訊息;alert 會立即打斷,status 則等空檔再念 -->
      <div
        class="border-ink-200 flex min-h-64 flex-col items-center justify-center gap-4 rounded-2xl border bg-white p-8 text-center shadow-sm"
      >
        <div
          class="flex size-12 items-center justify-center rounded-full"
          :class="
            isError ? 'bg-tertiary-500/15 text-tertiary-600' : 'bg-primary-100/50 text-primary-500'
          "
        >
          <CircleAlert v-if="isError" class="size-6" />
          <LoaderCircle v-else class="size-6 motion-safe:animate-spin" />
        </div>
        <p class="text-primary-500 text-base font-semibold">{{ message }}</p>
      </div>
    </div>
  </section>
</template>
