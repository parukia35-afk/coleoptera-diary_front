<script setup>
import { computed, ref, onMounted } from 'vue';
import RecordHero from './components/RecordHero.vue';
import FilterBar from './components/FilterBar.vue';
import RecordTable from './components/RecordTable.vue';
import NamingRules from './components/NamingRules.vue';
import StatusPanel from '@/components/StatusPanel.vue';

const API_BASE_URL = import.meta.env.VITE_API_BASE_URL;

const genusList = ref([]);
const records = ref([]);
const isLoading = ref(true);
const errorMessage = ref('');

// null 代表「全部」,否則是被選中的 genus.id
const selectedGenusId = ref(null);

const searchQuery = ref('');

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

// 全部資料:一個屬一包 { genus, rows, recordCount, topCaptive }
// 標題統計永遠算整個屬,所以這份不受篩選影響
const genusGroups = computed(() => {
  return [...genusList.value]
    .sort((a, b) => a.sortOrder - b.sortOrder)
    .map((genus) => {
      const rows = records.value
        .filter((record) => record.genus_id === genus.id)
        .map((record) => ({ ...record, status: getStatus(record) }))
        // 學名 a~z;學名相同(同種不同產地)再比產地,讓順序固定
        .sort(
          (a, b) =>
            a.scientificName.localeCompare(b.scientificName) ||
            (a.locality ?? '').localeCompare(b.locality ?? ''),
        );

      return {
        genus,
        rows,
        recordCount: rows.length,
        topCaptive: findTopCaptive(rows),
      };
    })
    .filter((group) => group.rows.length > 0);
});

// 單筆紀錄是否符合關鍵字(只比對三個名稱欄位,大小寫不分)
function matchesKeyword(row, keyword) {
  return [row.commonName, row.scientificName, row.japaneseName].some((text) =>
    text?.toLowerCase().includes(keyword),
  );
}

// 要顯示的資料:屬別篩選 → 搜尋,兩者同時作用
const displayedGroups = computed(() => {
  const keyword = searchQuery.value.trim().toLowerCase();

  return genusGroups.value
    .filter((group) => selectedGenusId.value === null || group.genus.id === selectedGenusId.value)
    .map((group) => {
      if (keyword === '') return group;
      // 只換掉 rows;recordCount、topCaptive 沿用原本的,所以標題統計不會跟著搜尋變
      return { ...group, rows: group.rows.filter((row) => matchesKeyword(row, keyword)) };
    })
    .filter((group) => group.rows.length > 0);
});

function resetFilters() {
  selectedGenusId.value = null;
  searchQuery.value = '';
}
</script>

<template>
  <RecordHero :records="records" :latest-year="latestYear" />
  <StatusPanel v-if="isLoading" message="資料載入中…" />
  <StatusPanel v-else-if="errorMessage" :message="errorMessage" is-error />
  <template v-else>
    <FilterBar v-model="selectedGenusId" v-model:query="searchQuery" :groups="genusGroups" />
    <RecordTable :groups="displayedGroups" @reset="resetFilters" />
    <NamingRules />
  </template>
</template>
