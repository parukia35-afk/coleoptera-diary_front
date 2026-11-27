<script setup>
import { ArrowRight, BookOpen } from '@lucide/vue';

// 一條規則 = 標題 + 說明(可省略) + 一個或多個情況
const rules = [
  {
    title: '台灣產或台灣蟲圈常用名稱',
    cases: [
      {
        condition:
          '如果是台灣原生的種類，或是雖然不產於台灣，但在台灣甲蟲圈中早已有固定叫法的外國種類，',
        result: '會直接使用台灣常見、大家比較熟悉的中文俗名。',
      },
    ],
  },
  {
    title: '中國產種類',
    intro: '如果是產自中國的種類，原則上會先參考《中國鍬甲大圖鑑》的命名方式，並依照以下情況處理：',
    cases: [
      {
        condition: '若俗名是從種小名拉丁文意譯而來，或是種小名本身就是地名，',
        result: '直接採用《中國鍬甲大圖鑑》的命名。',
      },
      {
        condition: '若俗名為「地名＋屬名＋鍬甲」的形式，且該物種只分布於中國，',
        result: '同樣直接採用《中國鍬甲大圖鑑》的命名。',
      },
      {
        condition:
          '若俗名為「地名＋屬名＋鍬甲」的形式，但該物種在其他國家或地區也有分布（不論是否為亞種），',
        result: '為避免地名造成混淆，會改採種小名的拉丁文音譯作為中文俗名。',
      },
    ],
  },
  {
    title: '較少見，但已有民間稱呼的種類',
    cases: [
      {
        condition: '如果是不算常見的種類，但在網路資料或社群中曾有人替它取過暱稱或中文名稱，',
        result: '會以種小名的拉丁文音譯作為主要的中文俗名。',
      },
    ],
  },
  {
    title: '目前沒有任何中文名稱的種類',
    cases: [
      {
        condition: '如果是極少見的種類，而且目前找不到中文文獻、網路資料，或任何既有的暱稱，',
        result: '將暫時標示為：〈尚無中文名〉',
      },
    ],
  },
];
</script>

<template>
  <section id="naming-rules" class="scroll-mt-12 py-12 md:py-16 lg:scroll-mt-32">
    <div class="page-container">
      <div class="border-ink-200 overflow-hidden rounded-2xl border bg-white shadow-sm">
        <!-- 區塊標題 -->
        <header class="border-ink-200 flex items-center gap-3 border-b p-5 md:px-8 md:py-6">
          <div
            class="bg-tertiary-500/15 text-tertiary-600 flex size-10 shrink-0 items-center justify-center rounded-lg"
          >
            <BookOpen class="size-5" aria-hidden="true" />
          </div>
          <h2 class="text-primary-500 text-lg font-bold md:text-xl">
            關於本篇資料所使用的中文俗名採用規則
          </h2>
        </header>

        <!-- 規則清單 -->
        <ol class="divide-ink-200 divide-y">
          <li
            v-for="(rule, index) in rules"
            :key="rule.title"
            class="flex flex-col gap-4 p-5 md:flex-row md:gap-8 md:p-8"
          >
            <!-- 左:編號與標題 -->
            <div class="flex items-start gap-3 md:w-72 md:shrink-0 lg:w-80">
              <span class="text-tertiary-600 font-mono text-2xl leading-7 font-bold">
                {{ String(index + 1).padStart(2, '0') }}
              </span>
              <h3 class="text-primary-500 text-base leading-7 font-bold">{{ rule.title }}</h3>
            </div>

            <!-- 右:說明與各種情況 -->
            <div class="min-w-0 flex-1">
              <p v-if="rule.intro" class="text-ink-400 mb-4 text-sm leading-7">
                {{ rule.intro }}
              </p>

              <ul class="grid gap-3" :class="{ 'lg:grid-cols-3': rule.cases.length > 1 }">
                <li
                  v-for="item in rule.cases"
                  :key="item.condition"
                  class="bg-paper-500 flex flex-col justify-between gap-3 rounded-xl p-4"
                >
                  <p class="text-ink-400 text-sm leading-7">{{ item.condition }}</p>
                  <p
                    class="border-ink-200 text-primary-500 flex items-start gap-2 border-t pt-3 text-sm leading-7 font-semibold"
                  >
                    <ArrowRight
                      class="text-tertiary-600 mt-1.5 size-4 shrink-0"
                      aria-hidden="true"
                    />
                    <span>{{ item.result }}</span>
                  </p>
                </li>
              </ul>
            </div>
          </li>
        </ol>
      </div>
    </div>
  </section>
</template>
