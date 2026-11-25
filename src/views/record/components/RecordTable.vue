<script setup>
import { SearchX } from '@lucide/vue';

defineProps({
  groups: Array,
});

defineEmits(['reset']);

function formatRecord(value) {
  return value === null ? '—' : value.toFixed(1);
}

// 各狀態對應的 badge 顏色(class 必須寫完整)
const statusStyles = {
  new: 'bg-tertiary-400 text-tertiary-700',
  broken: 'bg-primary-500 text-white',
  stale: 'bg-paper-600 text-ink-400',
  wildHigher: 'bg-secondary-500 text-primary-500',
};
</script>

<template>
  <section class="py-12 md:py-16">
    <!-- 容器 -->
    <div class="page-container flex flex-col gap-8">
      <!-- 空狀態:搜尋或篩選後沒有任何紀錄 -->
      <div
        v-if="groups.length === 0"
        class="border-ink-200 flex flex-col items-center rounded-2xl border border-dashed bg-white px-6 py-16 text-center"
      >
        <div
          class="bg-primary-500/10 text-primary-500 mb-5 flex size-14 items-center justify-center rounded-full"
        >
          <SearchX class="size-7" aria-hidden="true" />
        </div>
        <h2 class="text-primary-500 mb-2 text-xl font-bold">找不到符合的紀錄</h2>
        <p class="text-ink-400 mb-6 max-w-md text-sm leading-relaxed">
          試試其他關鍵字，或改用中文俗名、學名、日文俗名搜尋。若已選了特定屬別，也可以切回「全部」。
        </p>
        <button
          type="button"
          class="bg-primary-500 hover:bg-primary-400 cursor-pointer rounded-full px-5 py-2 text-sm font-medium text-white transition-colors"
          @click="$emit('reset')"
        >
          清除搜尋與篩選
        </button>
      </div>
      <!-- 單一屬的卡片 -->
      <article
        v-for="group in groups"
        :key="group.genus.id"
        class="border-paper-700 overflow-hidden rounded-2xl border bg-white"
      >
        <!-- 屬標題區 -->
        <header
          class="border-paper-700 bg-paper-600 border-b p-4 md:flex md:items-center md:justify-between md:gap-6 md:p-6"
        >
          <!-- 左:編號、名稱、描述 -->
          <div>
            <div class="flex items-center gap-3">
              <div
                class="bg-primary-500/10 text-primary-500 flex size-9 shrink-0 items-center justify-center rounded-lg text-sm font-bold"
              >
                {{ String(group.genus.sortOrder).padStart(2, '0') }}
              </div>
              <div class="flex flex-wrap items-baseline gap-x-3">
                <h2 class="text-primary-500 text-xl font-bold">{{ group.genus.nameZh }}</h2>
                <span class="text-primary-400 text-lg font-semibold italic">{{
                  group.genus.nameEn
                }}</span>
              </div>
            </div>

            <p v-if="group.genus.description" class="text-ink-400 mt-3 text-xs">
              {{ group.genus.description }}
            </p>
          </div>

          <!-- 右:統計 -->
          <div
            class="mt-3 flex flex-wrap items-center gap-x-3 gap-y-2 text-xs md:mt-0 md:shrink-0 md:flex-col md:items-end"
          >
            <span class="bg-primary-500/10 text-primary-500 rounded-full px-2.5 py-0.5 font-bold">
              {{ group.recordCount }} 種收錄
            </span>
            <span
              v-if="group.topCaptive"
              class="text-tertiary-600 flex items-center gap-1.5 font-medium"
            >
              <span class="bg-tertiary-500 size-1.5 rounded-full"></span>
              最高飼育:{{ formatRecord(group.topCaptive.captiveRecord) }} mm({{
                group.topCaptive.commonName
              }})
            </span>
          </div>
        </header>

        <!-- 表格 -->
        <div class="overflow-x-auto">
          <table class="text-ink-500 w-full border-collapse text-left text-sm">
            <thead>
              <tr class="border-paper-700 bg-paper-500 text-ink-400 border-b text-xs font-bold">
                <th class="px-3 py-2.5">
                  中文俗名
                  <span class="ml-1 hidden font-normal lg:inline">(Common Name)</span>
                </th>
                <th class="px-3 py-2.5">
                  學名
                  <span class="ml-1 hidden font-normal lg:inline">(Scientific Name)</span>
                </th>
                <th class="px-3 py-2.5 text-right">飼育紀錄 (mm)</th>
                <th class="hidden px-3 py-2.5 text-right sm:table-cell">野生紀錄 (mm)</th>
                <th class="hidden px-3 py-2.5 lg:table-cell">
                  日文俗名
                  <span class="ml-1 font-normal">(Japanese)</span>
                </th>
                <th class="hidden px-3 py-2.5 text-center sm:table-cell">登錄年</th>
                <th class="hidden px-3 py-2.5 md:table-cell">狀態</th>
              </tr>
            </thead>
            <tbody class="divide-paper-700 divide-y">
              <tr
                v-for="record in group.rows"
                :key="record.id"
                class="hover:bg-paper-600/50 transition-colors"
              >
                <td class="px-3 py-3">
                  <div class="flex items-center gap-2">
                    <span class="text-primary-500 font-bold">{{ record.commonName }}</span>
                    <span
                      v-if="record.isTaiwanese"
                      class="bg-primary-100 text-primary-500 hidden shrink-0 rounded px-1.5 py-0.5 text-xs font-semibold sm:inline-flex"
                    >
                      台灣種
                    </span>
                  </div>
                </td>
                <td class="text-ink-400 px-3 py-3 italic">{{ record.scientificName }}</td>
                <td class="text-tertiary-600 px-3 py-3 text-right font-semibold tabular-nums">
                  {{ formatRecord(record.captiveRecord) }}
                </td>
                <td
                  class="text-secondary-600 hidden px-3 py-3 text-right font-semibold tabular-nums sm:table-cell"
                >
                  {{ formatRecord(record.wildRecord) }}
                </td>
                <td class="text-ink-400 hidden px-3 py-3 lg:table-cell">
                  {{ record.japaneseName }}
                </td>
                <td class="text-ink-400 hidden px-3 py-3 text-center tabular-nums sm:table-cell">
                  {{ record.recordYear }}
                </td>
                <td class="hidden px-3 py-3 md:table-cell">
                  <span
                    v-if="record.status"
                    class="inline-flex rounded px-2 py-0.5 text-xs font-semibold whitespace-nowrap"
                    :class="statusStyles[record.status.type]"
                  >
                    {{ record.status.label }}
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </article>
    </div>
  </section>
</template>
