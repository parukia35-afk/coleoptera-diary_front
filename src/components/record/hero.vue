<template>
  <section class="bg-hero-dots py-12">
    <!-- 容器 -->
    <div class="page-container">
      <div
        class="mb-4 flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-semibold tracking-wide text-white/90"
      >
        <span class="bg-accent size-2 animate-pulse rounded-full"></span>
        BEKUWA 官方紀錄與權威飼育採集數據庫
      </div>

      <h1 class="mb-4 text-3xl font-extrabold text-white">世界鍬形蟲最大紀錄數據登錄庫</h1>

      <p class="text-base leading-relaxed text-white/80">
        完整收錄全球鍬形蟲科(Lucanidae)各屬之人工飼育極限(Breeding Record)與野外採集標本紀錄(Wild
        Record),以日本專業鍬形蟲雜誌《BEKUWA》登錄數據為依歸,按屬逐項嚴謹分類展示。
      </p>
    </div>
  </section>
</template>

<style scoped>
.bg-hero-dots {
  background-image:
    radial-gradient(rgb(255 255 255 /0.15) 1px, transparent 1px),
    linear-gradient(160deg, var(--color-secondary), var(--color-primary));
  background-size:
    24px 24px,
    auto;
}
</style>
