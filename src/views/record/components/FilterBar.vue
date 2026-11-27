<script setup>
// =====================================================================
// FilterBar:篩選列元件
//
// 職責:畫出「屬別按鈕 + 搜尋框」,讓使用者操作。
// 它自己「不做篩選」,只把使用者的選擇回報給父層(RecordPage),
// 由父層的 displayedGroups 真正去篩資料。
//
// 對外介面(跟父層溝通的管道):
//   :groups="genusGroups"          父 → 子,唯讀,要畫哪些屬別
//   v-model="selectedGenusId"      父 ⇄ 子,選中的屬 id(null = 全部)
//   v-model:query="searchQuery"    父 ⇄ 子,搜尋關鍵字
// =====================================================================

import { computed, onBeforeUnmount, onMounted, ref } from 'vue';
// 圖示元件。<script setup> 裡 import 的東西,template 可以直接用,不用另外註冊
import { Info } from '@lucide/vue';

// ---------------------------------------------------------------------
// 一、進出口:props 與 defineModel
// ---------------------------------------------------------------------

// 輸入:父層傳進來的屬別資料(genusGroups)。
// props 是唯讀的,不能在這裡寫 props.groups = ...
// script 裡要用 props.groups;template 裡可以直接寫 groups。
// type / required 只是開發時的檢查,不符合只會在 console 警告,不會讓程式壞掉。
const props = defineProps({
  groups: { type: Array, required: true },
});

// 輸入+輸出:目前選中的屬 id。
// defineModel 回傳一個「可讀可寫的 ref」:
//   讀 selected.value → 拿到父層 selectedGenusId 目前的值
//   寫 selected.value = 5 → 自動通知父層,父層的 selectedGenusId 變成 5
// null 代表「全部」。default 是父層沒傳值時的預設。
const selected = defineModel({ default: null });

// 輸入+輸出:搜尋關鍵字。有給名字 'query',對應父層的 v-model:query。
// 同一個元件要綁多個 v-model 時,就用名字區分。
const query = defineModel('query', { default: '' });

// ---------------------------------------------------------------------
// 二、整理資料:genera
// ---------------------------------------------------------------------

// 把父層給的 [{ genus, rows, recordCount, ... }]
// 轉成本元件只需要的 [{ id, name, latin }]。
// - 順序沿用 groups(父層已依 sortOrder 排好),所以 chip 與下拉選單順序自然正確
// - 傳入的是 genusGroups(全部資料),不是篩選後的,所以搜尋時屬別清單不會縮水
// - ({ genus }) 是參數解構,直接從每一包取出 genus 屬性
// - 箭頭函式回傳物件字面值時要多包一層小括號 ({ ... }),否則 { 會被當成函式本體
const genera = computed(() =>
  props.groups.map(({ genus }) => ({
    id: genus.id,
    name: genus.nameZh, // 中文名,顯示在按鈕上
    latin: genus.nameEn, // 學名,顯示在下拉面板的第二行
  })),
);

// ---------------------------------------------------------------------
// 三、本元件自己的狀態(父層不需要知道,所以用普通 ref)
// ---------------------------------------------------------------------

// 下拉面板是否展開
const isOpen = ref(false);

// 指向 template 裡 <div ref="rootRef"> 那個真正的 DOM 元素。
// 元件掛載後 Vue 會把元素放進 rootRef.value;掛載前是 null,所以初始值是 null。
// 變數名必須和 template 的 ref="rootRef" 字串一致,Vue 才配得起來。
const rootRef = ref(null);

// ---------------------------------------------------------------------
// 四、響應式 chip 數量:依螢幕寬度決定「直接顯示幾顆屬別按鈕」
//     螢幕 < 768:0 顆 / ≥ 768:4 顆 / ≥ 1280:6 顆
//     其餘屬別收進「更多屬別」下拉面板
// ---------------------------------------------------------------------

// 目前要顯示幾顆 chip。初始 0,onMounted 時會先算一次正確的值
const visibleCount = ref(0);

// matchMedia 是瀏覽器 API,等於 CSS 的 @media。
// 回傳物件有 .matches(現在符不符合)和 'change' 事件(符合狀態改變時觸發)。
// 不直接用 Tailwind 的 md:hidden,是因為 JS 需要「知道」顯示幾顆,
// 才能算出下面的 hiddenSelected;CSS 隱藏只是看不到,JS 並不知道。
const mqMd = window.matchMedia('(min-width: 768px)');
const mqXl = window.matchMedia('(min-width: 1280px)');

function updateVisibleCount() {
  // 要由大到小判斷:≥1280 時 mqMd.matches 也是 true,順序反了就永遠到不了 6
  visibleCount.value = mqXl.matches ? 6 : mqMd.matches ? 4 : 0;
}

// 要直接顯示的 chip:genera 的前 N 顆(排序最前面的 = 常用屬)。
// slice(0, 0) 是空陣列,所以手機版沒有 chip,只能從下拉選。
const visibleChips = computed(() => genera.value.slice(0, visibleCount.value));

// 選中的屬若「不在可見 chip 裡」(被收進下拉了),就回傳它,否則 null。
// 用途:畫面上要有地方顯示「現在選了什麼」,這時由「更多屬別」按鈕代表它。
const hiddenSelected = computed(() => {
  // 找出被選中的那個屬;選「全部」(null)時找不到,g 是 undefined
  const g = genera.value.find((x) => x.id === selected.value);
  // 運算子優先順序:&& 先於 ?:,等於 (g && !includes) ? g : null
  // includes 比的是物件參照:visibleChips 是 genera 的 slice,裡面是同一批物件,所以比得準
  return g && !visibleChips.value.includes(g) ? g : null;
});

// 「更多屬別」按鈕上的文字:有被藏起來的選中屬就顯示它的名字,否則顯示預設文字
// ?. 可選串接:hiddenSelected 是 null 時不報錯,得到 undefined
// ?? 空值合併:前面是 null / undefined 時改用右邊的預設值
const moreLabel = computed(() => hiddenSelected.value?.name ?? '更多屬別');

// 「更多屬別」按鈕是否要高亮(有被藏起來的選中屬時高亮)
const moreActive = computed(() => hiddenSelected.value !== null);

// ---------------------------------------------------------------------
// 五、互動函式
// ---------------------------------------------------------------------

// 選取某個屬(傳 null 代表「全部」)。chip 和下拉面板共用這個唯一出口。
// 資料流:select → selected.value 寫入 → 父層 selectedGenusId 更新
//         → 父層 displayedGroups 重算 → 表格變了
function select(id) {
  selected.value = id;
  isOpen.value = false; // 選完就關閉下拉
}

// 點擊空白處關閉下拉。
// 原理是事件冒泡:點頁面任何地方,click 都會往上傳到 document,
// 所以在 document 掛一個監聽就能抓到全頁的點擊。
function onDocClick(e) {
  // e.target 是被點到的元素;contains 判斷它是否在 rootRef 元素「裡面」(含自己)
  // 不在裡面 → 點到外面 → 關閉。rootRef.value && 是保險,確保元素存在才呼叫 contains
  // 「更多屬別」按鈕與下拉面板都在 rootRef 裡面,所以點它們不會被這裡關掉
  if (rootRef.value && !rootRef.value.contains(e.target)) isOpen.value = false;
}

// ---------------------------------------------------------------------
// 六、生命週期:跟瀏覽器打交道的監聽,「加」與「拆」要成對出現
// ---------------------------------------------------------------------

// 元件掛到畫面後執行一次
onMounted(() => {
  // 先手動算一次。visibleCount 初始是 0,不呼叫的話,
  // 要等使用者縮放視窗才會更新,一進頁面就會是 0 顆 chip
  updateVisibleCount();
  // 視窗寬度跨過 768 / 1280 時,重新計算顯示幾顆
  mqMd.addEventListener('change', updateVisibleCount);
  mqXl.addEventListener('change', updateVisibleCount);
  // 全頁點擊監聽,用來「點外面就關閉下拉」
  document.addEventListener('click', onDocClick);
});

// 元件被移除前執行一次:把上面加的監聽全部拆掉。
// 這些監聽掛在 document / matchMedia 物件上,活得比元件久;
// 不拆的話,元件消失後函式仍會被觸發(記憶體洩漏),
// 元件反覆出現還會讓監聽一層層疊加。
// removeEventListener 必須傳入「同一個函式參照」才拆得掉,
// 所以上面用具名函式,而不是在 addEventListener 裡寫匿名箭頭函式。
onBeforeUnmount(() => {
  mqMd.removeEventListener('change', updateVisibleCount);
  mqXl.removeEventListener('change', updateVisibleCount);
  document.removeEventListener('click', onDocClick);
});

// ---------------------------------------------------------------------
// 七、樣式(Tailwind class 字串,不含邏輯)
//     抽成變數是為了讓多顆按鈕共用,template 裡用 :class 組合
// ---------------------------------------------------------------------
const chipBase =
  'shrink-0 cursor-pointer rounded-full px-3.5 py-1.5 text-sm font-medium transition-colors';
const chipIdle = 'bg-paper-600 text-primary-500 hover:bg-paper-700'; // 未選中
const chipActive = 'bg-primary-500 text-white'; // 選中
</script>

<template>
  <!-- 外框。lg(≥1024)以上才 sticky:捲動時黏在 header 下方。
       top-20 = 80px,要和 header 高度一致,header 高度不同請調整 -->
  <section class="border-ink-200/60 bg-paper-500 z-40 border-b lg:sticky lg:top-20">
    <!-- 內容容器:手機上下堆疊(flex-col),lg 以上左右並排且兩端對齊(lg:flex-row)
         page-container 是 main.css 用 @utility 自訂的置中容器 -->
    <div
      class="page-container flex flex-col gap-3 py-3 lg:flex-row lg:items-center lg:justify-between"
    >
      <!-- ============ 左:屬別按鈕區 ============ -->
      <!-- ref="rootRef":給 onDocClick 判斷「有沒有點在篩選區裡面」。
           relative:讓裡面 absolute 的下拉面板以它為定位基準 -->
      <div ref="rootRef" class="relative flex flex-wrap items-center gap-2">
        <!-- 「全部」按鈕:select(null) → selected 變 null
             type="button":按鈕預設是 submit,放進 form 會觸發送出,養成習慣先寫上
             :aria-pressed:給螢幕閱讀器的屬性,表示「切換按鈕目前是否按下」
             :class 陣列寫法:共用樣式 + 依狀態挑選「選中 / 閒置」樣式 -->
        <button
          type="button"
          :aria-pressed="selected === null"
          :class="[chipBase, selected === null ? chipActive : chipIdle]"
          @click="select(null)"
        >
          全部
        </button>

        <!-- 屬別 chips:v-for 對 visibleChips 每一項畫一顆按鈕。
             visibleChips 的長度由螢幕寬度決定,所以視窗縮放時按鈕數量自動增減。
             :key 給 Vue 識別身分,用穩定不變的 id,不要用陣列索引 -->
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

        <!-- 「更多屬別」按鈕:虛線邊框 + 常駐箭頭,與一般 chip 區隔。
             @click 直接寫 isOpen = !isOpen:template 裡存取 ref 會自動解開,不用寫 .value
             文字 moreLabel:選中的屬被收進下拉時,這顆按鈕會代替它顯示名稱並高亮
             aria-haspopup / aria-expanded:無障礙屬性,告知會彈出清單與目前是否展開 -->
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
          <!-- 箭頭:同一元素可同時寫 class 與 :class,Vue 會合併。
               展開時加 rotate-180,配合 transition-transform 有翻轉動畫 -->
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

        <!-- 命名規範按鈕。注意:目前沒有 @click,點了不會有反應(預留位置)
             aria-hidden="true":圖示是裝飾,不需要螢幕閱讀器念出來 -->
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

        <!-- 下拉面板:永遠列出全部屬別(用 genera,不是 visibleChips)。
             v-if="isOpen":關閉時元素根本不存在於 DOM(v-show 則只是用 CSS 隱藏)
             absolute top-full left-0:貼在 rootRef 正下方、靠左;mt-2 留間距 -->
        <div
          v-if="isOpen"
          class="border-ink-200 absolute top-full left-0 z-50 mt-2 w-[min(88vw,30rem)] rounded-xl border bg-white p-3 shadow-lg"
        >
          <!-- 標題:genera.length 就是屬別總數 -->
          <div class="border-ink-200/60 text-ink-400 mb-2 border-b pb-2 text-xs font-semibold">
            全部屬別({{ genera.length }})
          </div>
          <!-- role="listbox" / "option" / aria-selected:無障礙語意,不影響畫面 -->
          <ul class="grid grid-cols-2 gap-1" role="listbox">
            <li v-for="g in genera" :key="g.id" role="option" :aria-selected="selected === g.id">
              <!-- 點選項呼叫 select(g.id),和 chip 共用同一個出口,選完自動關閉面板 -->
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
                <!-- min-h-4:學名為空時也保留高度,讓每格高度一致 -->
                <span class="text-ink-300 min-h-4 text-xs italic">{{ g.latin }}</span>
              </button>
            </li>
          </ul>
        </div>
      </div>

      <!-- ============ 右:搜尋框 ============ -->
      <div class="relative w-full lg:w-72">
        <!-- 放大鏡:純裝飾。absolute 定位在輸入框左側;
             pointer-events-none 讓點擊穿透它,不會擋到輸入框 -->
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
        <!-- v-model="query" 綁定 defineModel('query') 那個 ref:
             打字 → query.value 更新 → 父層 searchQuery 更新 → displayedGroups 重算 → 表格過濾
             pl-10:左邊留空間,避免文字壓到放大鏡 -->
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
