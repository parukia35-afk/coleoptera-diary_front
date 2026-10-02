/** @type {import('prettier').Config & import('prettier-plugin-tailwindcss').PluginOptions} */
export default {
  semi: true, // 程式碼結尾加不加分號
  singleQuote: true, // 要用單引號還雙引號？
  printWidth: 100, // 一行程式碼最多可以幾個字元(避免程式碼太長影響閱讀，會自動換行)
  plugins: ['prettier-plugin-tailwindcss'], // 自動把 Tailwind class 排序成官方建議的固定順序(不能自訂順序)
}
