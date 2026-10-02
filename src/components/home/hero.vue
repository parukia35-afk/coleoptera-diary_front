<template>
  <section class="hero-bg flex min-h-[819px] text-white">
    <!-- 高光 -->
    <div class="hero-glow"></div>
    <!-- 容器 -->
    <div
      class="Z-10 relative mx-auto flex max-w-[1440px] flex-col items-center gap-6 px-8 md:flex-row"
    >
      <!-- 文字欄 -->
      <div class="mb-20 flex flex-1 flex-col md:mb-0">
        <p class="text-accent-soft mb-3 text-sm tracking-wider uppercase">The Art of Observation</p>
        <h1 class="mb-9 text-3xl font-bold text-white">
          Meticulous records for the modern naturalist.
        </h1>
        <p class="text-primary-mist mb-15 max-w-lg text-lg opacity-90">
          Document the delicate lifecycle of stag beetles, rhinoceros beetles, and flower chafers
          with precise tracking, breeding logs, and environmental data.
        </p>
        <div class="flex gap-3">
          <button
            class="bg-accent hover:bg-accent-deep rounded-lg px-6 py-3 text-white transition-all duration-300 hover:-translate-y-1 hover:shadow-xl"
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
            <p class="text-primary mb-1 text-sm font-semibold">Lucanus cervus</p>
            <p class="text-text-soft text-sm">L3 Larval Stage Logged</p>
          </div>
          <TrendingUp class="text-accent" />
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
  background: linear-gradient(135deg, #0f4743 0%, #194f4a 100%);
  position: relative;
  overflow: hidden;
}
/* 背景中淡淡的網格線 */
.hero-bg::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(163, 215, 208, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(163, 215, 208, 0.05) 1px, transparent 1px);
  background-size: 32px 32px;
  opacity: 0.5;
}
/* hero圖上的浮動玻璃卡片 */
.glass-panel {
  background: rgba(250, 249, 245, 0.7);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(191, 200, 198, 0.3);
}
/* 背景高光 */
.hero-glow {
  position: absolute;
  top: -20%;
  left: -10%;
  width: 70%;
  height: 70%;
  background: radial-gradient(circle, rgba(168, 101, 74, 0.15) 0%, transparent 70%);
  border-radius: 50%;
  filter: blur(40px);
  pointer-events: none;
}
</style>
