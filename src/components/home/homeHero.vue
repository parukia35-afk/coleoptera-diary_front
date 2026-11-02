<template>
  <section class="hero-bg flex min-h-[819px] text-white">
    <!-- 高光 -->
    <div class="hero-glow"></div>
    <!-- 容器 -->
    <div class="page-container relative z-10 flex flex-col items-center gap-6 md:flex-row">
      <!-- 文字欄 -->
      <div class="mb-20 flex flex-1 flex-col md:mb-0">
        <p class="text-tertiary-400 mb-3 text-sm tracking-wider uppercase">
          The Art of Observation
        </p>
        <h1 class="mb-9 text-3xl font-bold text-white">
          Meticulous records for the modern naturalist.
        </h1>
        <p class="text-primary-100 mb-15 max-w-lg text-lg opacity-90">
          Document the delicate lifecycle of stag beetles, rhinoceros beetles, and flower chafers
          with precise tracking, breeding logs, and environmental data.
        </p>
        <div class="flex gap-3">
          <button
            class="bg-tertiary-700 hover:bg-tertiary-600 rounded-lg px-6 py-3 text-white transition-all duration-300 hover:-translate-y-1 hover:shadow-xl"
          >
            Start Tracking
          </button>
          <button
            class="rounded-lg border border-white/20 bg-white/10 px-6 py-3 text-white backdrop-blur-sm transition-all hover:bg-white/20"
          >
            Explore Database
          </button>
        </div>
      </div>

      <!-- 圖片欄 -->
      <div class="relative aspect-4/5 w-full flex-1 md:aspect-square md:max-w-[554px]">
        <img
          class="h-full w-full rounded-xl border border-white/10 object-cover shadow-2xl"
          src="https://lh3.googleusercontent.com/aida-public/AB6AXuBwl_3NFS3IaUOuuogbLLgkmgeuxBgfVsyfkonS0Pgihqmgj45ofqCc0OTJQbdI2cFAla38zozO8fWcubcXMyy8TC7F1kaHNT9HbRPBKlxnurDC1uG5n_H-2B9OMj5to-JhBs-OJeTgFC31V1f4j-JflXWCrfKF7YJggAWdGwAm4Hyb1Ij4AJAFgb75-M-lXGtdPK8_qF8lubCFoTg2k2K8oCdKX2yiBm-qXM6RkbB7ywv05FeZmL2IfQ"
          alt="Lucanus cervus 雄鍬形蟲棲息在腐朽橡木上的特寫照片"
        />
        <div
          class="glass-panel absolute right-6 bottom-6 left-6 flex items-center justify-between rounded-lg p-4"
        >
          <div>
            <p class="text-ink-500 mb-1 text-sm font-semibold">Lucanus cervus</p>
            <p class="text-ink-400 text-sm">L3 Larval Stage Logged</p>
          </div>
          <TrendingUp class="text-tertiary-600" />
        </div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { TrendingUp } from '@lucide/vue';
</script>

<style scoped>
/* section背景 */
.hero-bg {
  background: linear-gradient(135deg, var(--color-primary-500) 0%, var(--color-primary-400) 100%);
  position: relative;
  overflow: hidden;
}
/* 背景中淡淡的網格線 */
.hero-bg::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(
      color-mix(in srgb, var(--color-primary-200) 5%, transparent) 1px,
      transparent 1px
    ),
    linear-gradient(
      90deg,
      color-mix(in srgb, var(--color-primary-200) 5%, transparent) 1px,
      transparent 1px
    );
  background-size: 32px 32px;
  opacity: 0.5;
}
/* hero圖上的浮動玻璃卡片 */
.glass-panel {
  background: color-mix(in srgb, var(--color-paper-500) 70%, transparent);
  backdrop-filter: blur(12px);
  border: 1px solid color-mix(in srgb, var(--color-ink-200) 30%, transparent);
}
/* 背景高光 */
.hero-glow {
  position: absolute;
  top: -20%;
  left: -10%;
  width: 70%;
  height: 70%;
  background: radial-gradient(
    circle,
    color-mix(in srgb, var(--color-tertiary-500) 15%, transparent) 0%,
    transparent 70%
  );
  border-radius: 50%;
  filter: blur(40px);
  pointer-events: none;
}
</style>
