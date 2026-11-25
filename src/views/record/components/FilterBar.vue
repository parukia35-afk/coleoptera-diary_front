<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
import { Info } from '@lucide/vue';

interface Genus {
  id: number;
  name: string;
  latin: string;
}

const props = defineProps<{
  groups: { genus: { id: number; nameZh: string; nameEn: string } }[];
}>();

// 目前選中的屬 id,null = 全部;資料由父層持有
const selected = defineModel<number | null>({ default: null });

// 搜尋關鍵字;父層用 v-model:query 綁定
const query = defineModel<string>('query', { default: '' });

// 順序 = 資料庫的 sortOrder(genusGroups 已排好)
const genera = computed<Genus[]>(() =>
  props.groups.map(({ genus }) => ({
    id: genus.id,
    name: genus.nameZh,
    latin: genus.nameEn,
  })),
);

const isOpen = ref(false);
const rootRef = ref<HTMLElement | null>(null);

// ---- 依斷點決定顯示幾顆常用 chip ----
// <768: 0 顆 / ≥768: 4 顆 / ≥1280: 6 顆
const visibleCount = ref(0);
const mqMd = window.matchMedia('(min-width: 768px)');
const mqXl = window.matchMedia('(min-width: 1280px)');

function updateVisibleCount() {
  visibleCount.value = mqXl.matches ? 6 : mqMd.matches ? 4 : 0;
}

const visibleChips = computed(() => genera.value.slice(0, visibleCount.value));

// 選中的屬若不在可見 chip 裡,就由「更多屬別」按鈕代表它
const hiddenSelected = computed(() => {
  const g = genera.value.find((x) => x.id === selected.value);
  return g && !visibleChips.value.includes(g) ? g : null;
});
const moreLabel = computed(() => hiddenSelected.value?.name ?? '更多屬別');
const moreActive = computed(() => hiddenSelected.value !== null);

function select(id: number | null) {
  selected.value = id;
  isOpen.value = false;
}

function onDocClick(e: MouseEvent) {
  if (rootRef.value && !rootRef.value.contains(e.target as Node)) isOpen.value = false;
}

onMounted(() => {
  updateVisibleCount();
  mqMd.addEventListener('change', updateVisibleCount);
  mqXl.addEventListener('change', updateVisibleCount);
  document.addEventListener('click', onDocClick);
});
onBeforeUnmount(() => {
  mqMd.removeEventListener('change', updateVisibleCount);
  mqXl.removeEventListener('change', updateVisibleCount);
  document.removeEventListener('click', onDocClick);
});

// ---- 樣式 ----
const chipBase =
  'shrink-0 cursor-pointer rounded-full px-3.5 py-1.5 text-sm font-medium transition-colors';
const chipIdle = 'bg-paper-600 text-primary-500 hover:bg-paper-700';
const chipActive = 'bg-primary-500 text-white';
</script>

<template>
  <!-- lg 以上才 sticky;top-20 對應 header 高度,若 header 高度不同請調整 -->
  <section class="border-ink-200/60 bg-paper-500 z-40 border-b lg:sticky lg:top-20">
    <div
      class="page-container flex flex-col gap-3 py-3 lg:flex-row lg:items-center lg:justify-between"
    >
      <!-- 左:屬別 chips -->
      <div ref="rootRef" class="relative flex flex-wrap items-center gap-2">
        <button
          type="button"
          :aria-pressed="selected === null"
          :class="[chipBase, selected === null ? chipActive : chipIdle]"
          @click="select(null)"
        >
          全部
        </button>

        <button
          v-for="g in visibleChips"
          :key="g.id"
          type="button"
          :aria-pressed="selected === g.id"
          :class="[chipBase, selected === g.id ? chipActive : chipIdle]"
          @click="select(g.id)"
        >
          {{ g.name }}
        </button>

        <!-- 「更多屬別」:虛線邊框 + 常駐箭頭,與一般 chip 區隔 -->
        <button
          type="button"
          aria-haspopup="listbox"
          :aria-expanded="isOpen"
          :class="[
            chipBase,
            'flex items-center gap-1 border border-dashed',
            moreActive
              ? 'bg-primary-500 border-primary-200 text-white'
              : 'border-ink-300 text-primary-500 hover:bg-paper-600 bg-transparent',
          ]"
          @click="isOpen = !isOpen"
        >
          {{ moreLabel }}
          <svg
            class="h-4 w-4 transition-transform"
            :class="isOpen ? 'rotate-180' : ''"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M5.23 7.21a.75.75 0 0 1 1.06.02L10 11.17l3.71-3.94a.75.75 0 1 1 1.08 1.04l-4.25 4.5a.75.75 0 0 1-1.08 0l-4.25-4.5a.75.75 0 0 1 .02-1.06Z"
              clip-rule="evenodd"
            />
          </svg>
        </button>

        <!-- 命名規範按鈕 -->
        <button
          type="button"
          :class="[
            chipBase,
            'border-ink-200 text-ink-400 hover:text-primary-500 hover:border-primary-400 flex items-center gap-1 border bg-transparent',
          ]"
        >
          <Info class="h-4 w-4" aria-hidden="true" />
          命名規範
        </button>

        <!-- 下拉面板:永遠列出全部 15 屬 -->
        <div
          v-if="isOpen"
          class="border-ink-200 absolute top-full left-0 z-50 mt-2 w-[min(88vw,30rem)] rounded-xl border bg-white p-3 shadow-lg"
        >
          <div class="border-ink-200/60 text-ink-400 mb-2 border-b pb-2 text-xs font-semibold">
            全部屬別({{ genera.length }})
          </div>
          <ul class="grid grid-cols-2 gap-1" role="listbox">
            <li v-for="g in genera" :key="g.id" role="option" :aria-selected="selected === g.id">
              <button
                type="button"
                class="flex w-full cursor-pointer flex-col rounded-lg px-3 py-2 text-left transition-colors"
                :class="
                  selected === g.id
                    ? 'bg-primary-100 text-primary-500'
                    : 'text-ink-500 hover:bg-paper-600'
                "
                @click="select(g.id)"
              >
                <span class="text-sm font-semibold">{{ g.name }}</span>
                <span class="text-ink-300 min-h-4 text-xs italic">{{ g.latin }}</span>
              </button>
            </li>
          </ul>
        </div>
      </div>

      <!-- 右:搜尋框 -->
      <div class="relative w-full lg:w-72">
        <svg
          class="text-ink-300 pointer-events-none absolute top-1/2 left-3.5 h-4 w-4 -translate-y-1/2"
          viewBox="0 0 20 20"
          fill="none"
          stroke="currentColor"
          stroke-width="1.8"
          aria-hidden="true"
        >
          <circle cx="9" cy="9" r="6" />
          <path d="m14 14 3.5 3.5" stroke-linecap="round" />
        </svg>
        <input
          v-model="query"
          type="text"
          placeholder="搜尋學名、中文名或日文名…"
          class="border-ink-200 bg-paper-600/60 text-ink-500 placeholder:text-ink-300 focus:border-primary-400 focus:ring-primary-400 w-full rounded-full border py-1.5 pr-4 pl-10 text-sm focus:ring-1 focus:outline-none"
        />
      </div>
    </div>
  </section>
</template>
