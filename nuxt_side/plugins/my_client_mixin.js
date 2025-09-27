// グローバルミックスイン
// https://nuxtjs.org/ja/docs/directory-structure/plugins/#%E3%82%B0%E3%83%AD%E3%83%BC%E3%83%90%E3%83%AB%E3%83%9F%E3%83%83%E3%82%AF%E3%82%B9%E3%82%A4%E3%83%B3
// グローバルミックスインは Nuxt プラグインで簡単に追加できますが、正しく処理しないとトラブルやメモリリークが発生する可能性があります。アプリケーションにグローバルミックスインを追加するときは、常にフラグを使用して複数回登録しないようにする必要があります：
// import Vue from "vue"
//
// // 他の mixin と衝突しないように
// // フラグの名前は必ずユニークなものにしてください。
// if (!Vue.__my_mixin__) {
//   Vue.__my_mixin__ = true
//   Vue.mixin({ ... }) // ミックスインを設定する
// }

import Vue from "vue"

import { vue_dialog            } from "./vue_dialog.js"
import { vue_actioncable       } from "./vue_actioncable.js"
import { vue_clipboard         } from "./vue_clipboard.js"
import { vue_general_kifu_copy         } from "./vue_general_kifu_copy.js"
import { vue_scroll            } from "./vue_scroll.js"
import { vue_mounted_next      } from "./vue_mounted_next.js"
import { vue_support_route } from "./vue_support_route.js"
import { vue_talk              } from "./vue_talk.js"
import { vue_sfx               } from "./vue_sfx.js"

if (!Vue.__client_js_mixin__) {
  Vue.__client_js_mixin__ = true
  Vue.mixin({
    mixins: [
      vue_dialog,
      vue_clipboard,
      vue_general_kifu_copy,
      vue_actioncable,
      vue_scroll,
      vue_mounted_next,
      vue_support_route,
      vue_talk,
      vue_sfx,
    ],
  })
}
