<script setup>
import { computed } from 'vue';

const props = defineProps({
  records: Array,
  latestYear: Number,
});

// 找出某欄位最大的那一列;略過 null(例如沒有野外紀錄),全部都是 null 就回傳 null
function findMax(rows, field) {
  let top = null;
  for (const row of rows) {
    if (row[field] === null) continue;
    if (top === null || row[field] > top[field]) top = row;
  }
  return top;
}

// 四張統計卡的內容。資料還沒載入(records 是空陣列)時,數字顯示「—」
const stats = computed(() => {
  const rows = props.records;
  const hasData = rows.length > 0;

  const topCaptive = findMax(rows, 'captiveRecord');
  const topWild = findMax(rows, 'wildRecord');
  const genusCount = new Set(rows.map((row) => row.genus_id)).size;
  const latestCount = rows.filter((row) => row.recordYear === props.latestYear).length;

  return [
    {
      label: '收錄分類群',
      value: hasData ? String(rows.length) : '—',
      unit: '',
      note: hasData ? `涵蓋 ${genusCount} 個屬` : '',
    },
    {
      label: '飼育紀錄極限',
      value: topCaptive ? topCaptive.captiveRecord.toFixed(1) : '—',
      unit: topCaptive ? 'mm' : '',
      note: topCaptive ? topCaptive.commonName : '',
    },
    {
      label: '野外紀錄極限',
      value: topWild ? topWild.wildRecord.toFixed(1) : '—',
      unit: topWild ? 'mm' : '',
      note: topWild ? topWild.commonName : '',
    },
    {
      label: '最新更新年份',
      value: hasData ? String(props.latestYear) : '—',
      unit: '',
      note: hasData ? `該年度更新 ${latestCount} 筆` : '',
    },
  ];
});
</script>

<template>
  <section class="bg-hero-dots py-12 md:py-16">
    <!-- 容器 -->
    <div class="page-container flex flex-col gap-8 lg:flex-row lg:items-end lg:justify-between">
      <!-- 標題與介紹 -->
      <div class="max-w-3xl">
        <div
          class="mb-4 inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-3 py-1 text-xs font-semibold tracking-wide text-white/90"
        >
          <span class="bg-tertiary-400 size-2 animate-pulse rounded-full"></span>
          BEKUWA 官方紀錄與權威飼育採集數據庫
        </div>

        <h1 class="mb-4 text-3xl leading-tight font-extrabold text-white md:text-4xl lg:text-5xl">
          世界鍬形蟲最大紀錄數據登錄庫
        </h1>

        <p class="text-base leading-relaxed text-white/80 md:text-lg">
          完整收錄全球鍬形蟲科(Lucanidae)各屬之人工飼育極限(Breeding Record)與野外採集標本紀錄(Wild
          Record),以日本專業鍬形蟲雜誌《BEKUWA》登錄數據為依歸,按屬逐項嚴謹分類展示。
        </p>
      </div>

      <!-- 統計卡 -->
      <div class="grid grid-cols-2 gap-3 md:grid-cols-4 lg:w-1/3 lg:shrink-0 lg:grid-cols-2">
        <div
          v-for="stat in stats"
          :key="stat.label"
          class="rounded-xl border border-white/10 bg-white/10 p-4"
        >
          <p class="mb-1 text-xs font-semibold tracking-wider text-white/70">{{ stat.label }}</p>
          <p class="mb-0.5 text-2xl font-extrabold text-white tabular-nums md:text-3xl">
            {{ stat.value
            }}<span v-if="stat.unit" class="ml-0.5 text-sm font-normal">{{ stat.unit }}</span>
          </p>
          <p class="text-paper-500/80 min-h-4 text-xs">{{ stat.note }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.bg-hero-dots {
  background-image:
    radial-gradient(rgb(255 255 255 / 0.15) 1px, transparent 1px),
    linear-gradient(160deg, var(--color-primary-500), var(--color-primary-400));
  background-size:
    24px 24px,
    auto;
}
</style>
