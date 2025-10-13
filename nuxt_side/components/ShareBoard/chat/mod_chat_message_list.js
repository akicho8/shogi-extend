// チャットの発言リスト

import _ from "lodash"
import dayjs from "dayjs"
import { MessageRecord } from "./message_record.js"
import { GX } from "@/components/models/gs.js"

export const mod_chat_message_list = {
  data() {
    return {
      message_records: [],
    }
  },
  methods: {
    ml_clear() {
      this.message_records = []
    },

    // 発言の追加 (単に最後にpushする)
    ml_create(attributes) {
      this.ml_push_record(MessageRecord.create(attributes))
    },

    ml_push_record(message_record) {
      this.message_records.push(message_record)
      this.ml_truncate_and_scroll_to_bottom()
    },

    ml_truncate_and_scroll_to_bottom() {
      if (this.mh_rows_size_max >= 0) {
        this.message_records = _.takeRight(this.message_records, this.mh_rows_size_max)
      }
      this.$nextTick(() => this.ml_scroll_to_bottom())
    },

    // デバッグ用
    ml_test() {
      this.ml_bot_puts("OK")
    },

    // Bot用 (自分だけが見える)
    ml_bot_puts(content) {
      this.ml_create({from_user_name: "Bot", content: content})
    },

    // 自分だけが見える発言
    ml_puts(content) {
      this.ml_create({
        from_user_name: this.user_name,
        content: content,
        from_avatar_path: this.g_current_user?.avatar_path,
      })
    },

    // 一番下までスクロール
    ml_scroll_to_bottom() {
      this.scroll_to_bottom(this.ml_root_el())
    },

    // .SbMessageBox の要素を取得する (存在確認にも使う)
    ml_root_el() {
      return document.querySelector(".SbMessageBox")
    },

    // .SbMessageBox の要素を取得する (かならずある)
    ml_root_el_fetch() {
      const el = this.ml_root_el()
      GX.assert(el, "チャットモーダルが開いていない状態で .SbMessageBox を参照しようとしいる")
      return el
    },

    // ml_root_el があるときだけそれを引数にして処理を行う
    ml_root_el_block(block) {
      const el = this.ml_root_el()
      if (el) {
        return block(el)
      }
    },

    // 表示してもよいか？
    ml_show_p(record) {
      if (!this.order_enable_p) {                      // そもそも順番設定をしてないなら見える
        return true
      }
      if (this.received_from_self(record)) {           // 自分が送信者なら状況に限らず見える
        return true
      }
      if (this.i_am_watcher_p) {                       // 自分が観戦者なら見える
        return true
      }
      if (record.message_scope_key === "ms_public") {  // この条件までくるのは対局者で公開スコープなら見える
        return true
      }
      return false
    },

    // 最終的に見える内容
    ml_show(e) {
      if (this.ml_show_p(e)) {
        return e.auto_linked_message
      } else {
        return e.invisible_message
      }
    },

    // list を MessageRecord 化して追加して整列する
    ml_concat(list) {
      list = list.map(e => MessageRecord.create(e))
      list = [...list, ...this.message_records]
      list = _.uniqBy(list, "unique_key")
      list = _.sortBy(list, "performed_at")
      this.message_records = list
    },
  },
  computed: {
    ml_count() { return this.message_records.length }, // 表示件数 (保持件数)
  },
}
