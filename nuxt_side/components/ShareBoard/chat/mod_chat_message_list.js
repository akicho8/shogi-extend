// チャットの発言リスト

import _ from "lodash"
import dayjs from "dayjs"
import { MessageRecord } from "./message_record.js"

export const mod_chat_message_list = {
  data() {
    return {
      message_list: [],
    }
  },
  mounted() {
    // this.ml_add({content: "a"})
  },
  methods: {
    // 発言の追加 (単に最後にpushする)
    ml_add(attributes) {
      this.ml_add_xmessage(MessageRecord.create(attributes))
    },

    // list を MessageRecord 化して追加して整列する
    ml_merge(list) {
      list = list.map(e => MessageRecord.create(e))
      list = [...list, ...this.message_list]
      list = _.uniqBy(list, "unique_key")
      list = _.sortBy(list, "performed_at")
      this.message_list = list
    },

    ml_add_xmessage(message_record) {
      this.message_list.push(message_record)
      this.ml_truncate_and_scroll_to_bottom()
    },

    ml_truncate_and_scroll_to_bottom() {
      if (this.mh_rows_size_max >= 0) {
        this.message_list = _.takeRight(this.message_list, this.mh_rows_size_max)
      }
      this.ml_scroll_to_bottom()
    },

    // デバッグ用
    ml_test() {
      this.local_bot_say("OK")
    },

    // Bot用 (自分だけが見える)
    local_bot_say(content) {
      this.ml_add({from_user_name: "Bot", content: content})
    },

    // 自分だけが見える発言
    local_say(content) {
      this.ml_add({
        from_user_name: this.user_name,
        content: content,
        from_avatar_path: this.g_current_user?.avatar_path,
      })
    },

    // 一番下までスクロール
    ml_scroll_to_bottom() {
      const elem = document.querySelector(".SbMessageList")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },

    ml_clear() {
      this.message_list = []
    },

    // 表示してもよいか？
    ml_show_p(e) {
      let exec = true
      if (e.message_scope_key === "ms_private") { // 観戦者宛のときに、
        if (!this.received_from_self(e)) {        // 自分が送信者ではなく、
          if (this.self_is_member_p) {            // 自分が対局者の場合は、
            exec = false                          // 受信しない
          }
        }
      }
      return exec
    },

    // 最終的に見える内容
    ml_show(e) {
      if (this.ml_show_p(e)) {
        return e.auto_linked_message
      } else {
        return e.invisible_message
      }
    },
  },
  computed: {
    ml_count() { return this.message_list.length },
  },
}
