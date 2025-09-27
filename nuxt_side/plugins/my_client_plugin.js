// Nuxt.js ドキュメントより
// Vue.use()、Vue.component() を使用しないでください
// またグローバルに、Nuxt インジェクション専用のこの関数内に Vue を接続しないでください
// サーバーサイドでメモリリークが発生します。

import { Beat } from "@/components/models/beat.js"

// $root とコンテキストの挿入
// https://nuxtjs.org/ja/docs/directory-structure/plugins/#root-%E3%81%A8%E3%82%B3%E3%83%B3%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88%E3%81%AE%E6%8C%BF%E5%85%A5
export default ({app}, inject) => {
  inject("beat", Beat)
}
