// チャットの発言履歴

import _ from "lodash"
import dayjs from "dayjs"
import { MessageDto } from "./message_dto.js"

export const mod_chat_logs = {
  data() {
    return {
      message_logs: [],
    }
  },
  mounted() {
    // this.ml_add({message: "a"})
  },
  methods: {
    // 発言の追加 (単に最後にpushする)
    ml_add(attributes) {
      this.ml_add_xmessage(MessageDto.create(attributes))
    },

    // list を MessageDto 化して追加して整列する
    ml_merge(list) {
      list = list.map(e => MessageDto.create(e))
      list = [...list, ...this.message_logs]
      list = _.uniqBy(list, "unique_key")
      list = _.sortBy(list, "performed_at")
      this.message_logs = list
    },

    ml_add_xmessage(message_dto) {
      this.message_logs.push(message_dto)
      this.ml_truncate_and_scroll_to_bottom()
    },

    ml_truncate_and_scroll_to_bottom() {
      this.message_logs = _.takeRight(this.message_logs, this.AppConfig.CHAT_MESSAGES_SIZE_MAX_OF_MAX)
      this.ml_scroll_to_bottom()
    },

    // デバッグ用
    ml_test() {
      this.local_bot_say("OK")
    },

    // Bot用 (自分だけが見える)
    local_bot_say(message) {
      this.ml_add({from_user_name: "Bot", message: message})
    },

    // 自分だけが見える発言
    local_say(message) {
      this.ml_add({
        from_user_name: this.user_name,
        message: message,
        from_avatar_path: this.g_current_user?.avatar_path,
      })
    },

    // 一番下までスクロール
    ml_scroll_to_bottom() {
      const elem = document.querySelector(".SbMessageLog")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },

    ml_clear() {
      this.message_logs = []
    },

    // 表示してもよいか？
    ml_show_p(e) {
      let exec = true
      if (e.message_scope_key === "is_message_scope_private") { // 観戦者宛のときに、
        if (!this.received_from_self(e)) {                      // 自分が送信者ではなく、
          if (this.self_is_member_p) {                          // 自分が対局者の場合は、
            exec = false                                        // 受信しない
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
}
