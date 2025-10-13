// Nuxt.js ドキュメントより
// Vue.use()、Vue.component() を使用しないでください
// またグローバルに、Nuxt インジェクション専用のこの関数内に Vue を接続しないでください
// サーバーサイドでメモリリークが発生します。

import { TimeUtil } from "@/components/models/time_util.js"
import { DebugUtil } from "@/components/models/debug_util.js"
import { KifuVo } from "@/components/models/kifu_vo.js"
import { PiyoShogiTypeCurrent } from "@/components/models/piyo_shogi_type_current.js"
import { GX } from "@/components/models/gs.js"
import { marked } from 'marked'
import isMobile from "ismobilejs"

// $root とコンテキストの挿入
// https://nuxtjs.org/ja/docs/directory-structure/plugins/#root-%E3%81%A8%E3%82%B3%E3%83%B3%E3%83%86%E3%82%AD%E3%82%B9%E3%83%88%E3%81%AE%E6%8C%BF%E5%85%A5
export default ({app}, inject) => {
  inject("GX", GX)
  inject("time", TimeUtil)
  inject("debug", DebugUtil)
  inject("KifuVo", KifuVo)
  inject("PiyoShogiTypeCurrent", PiyoShogiTypeCurrent)
  inject('marked', marked)
  inject("user_agent_info", process.client ? isMobile(navigator) : isMobile({}))
}
