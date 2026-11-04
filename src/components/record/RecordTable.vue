<script setup>
import { computed, ref, onMounted } from 'vue';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

const genusList = ref([]);
const records = ref([]);
const isLoading = ref(true);
const errorMessage = ref('');

async function fetchJson(path) {
  const response = await fetch(`${API_BASE_URL}${path}`);
  if (!response.ok) {
    throw new Error(`請求 ${path} 失敗（狀態碼 ${response.status}）`);
  }
  return response.json();
}

onMounted(async () => {
  try {
    const [genera, stagRecords] = await Promise.all([
      fetchJson('/api/genera'),
      fetchJson('/api/stag-records'),
    ]);
    genusList.value = genera;
    records.value = stagRecords;
  } catch (error) {
    console.error(error);
    errorMessage.value = '資料載入失敗，請稍後再試';
  } finally {
    isLoading.value = false;
  }
});

function formatRecord(value) {
  return value === null ? '—' : value.toFixed(1);
}

// 「今年」= 資料中最大的 recordYear
const latestYear = computed(() => Math.max(...records.value.map((record) => record.recordYear)));

// 依優先順序判斷狀態,沒有符合的回傳 null
function getStatus(record) {
  const year = latestYear.value;

  if (record.recordYear === year && record.previousYear === null) {
    return { type: 'new', label: '新登錄' };
  }
  if (record.recordYear === year) {
    return { type: 'broken', label: '新紀錄' };
  }

  const yearsSince = year - record.recordYear;
  if (yearsSince >= 3) {
    return { type: 'stale', label: `已${yearsSince}年未突破` };
  }

  if (record.wildRecord !== null && Number(record.wildRecord) > Number(record.captiveRecord)) {
    return { type: 'wildHigher', label: '野外大於飼育' };
  }

  return null;
}

// 找出飼育紀錄最大的那一列(沒有資料時回傳 null)
function findTopCaptive(rows) {
  if (rows.length === 0) return null;

  let top = rows[0];
  for (const row of rows) {
    if (Number(row.captiveRecord) > Number(top.captiveRecord)) {
      top = row;
    }
  }
  return top;
}

// 整理成「一個屬一包」:{ genus, rows, recordCount, topCaptive }
const genusGroups = computed(() => {
  return [...genusList.value]
    .sort((a, b) => a.sortOrder - b.sortOrder)
    .map((genus) => {
      const rows = records.value
        .filter((record) => record.genus_id === genus.id)
        .map((record) => ({ ...record, status: getStatus(record) }));

      return {
        genus,
        rows,
        recordCount: rows.length,
        topCaptive: findTopCaptive(rows),
      };
    })
    .filter((group) => group.rows.length > 0);
});

// 各狀態對應的 badge 顏色(class 必須寫完整,見下方說明)
const statusStyles = {
  new: 'bg-tertiary-400 text-tertiary-700',
  broken: 'bg-primary-500 text-white',
  stale: 'bg-paper-600 text-ink-400',
  wildHigher: 'bg-secondary-500 text-primary-500',
};
</script>

<template>
  <p v-if="isLoading">載入中…</p>
  <p v-else-if="errorMessage">{{ errorMessage }}</p>
  <template v-else>
    <section class="py-12 md:py-16">
      <!-- 容器 -->
      <div class="page-container flex flex-col gap-8">
        <!-- 單一屬的卡片 -->
        <article
          v-for="group in genusGroups"
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
</template>
