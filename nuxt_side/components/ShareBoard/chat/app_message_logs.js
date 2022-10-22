// チャットの発言履歴

import _ from "lodash"
import dayjs from "dayjs"
import { MessageDto } from "./message_dto.js"

export const app_message_logs = {
  data() {
    return {
      message_logs: [],
    }
  },
  methods: {
    // 発言の追加
    ml_add(params) {
      this.ml_add_xmessage(MessageDto.create(params))
    },

    ml_add_xmessage(message_dto) {
      this.message_logs.push(message_dto)
      this.message_logs = _.takeRight(this.message_logs, this.AppConfig.CHAT_MESSAGES_SIZE_MAX)
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
        from_avatar_path: this.g_current_user.avatar_path,
      })
    },

    // 一番下までスクロール
    ml_scroll_to_bottom() {
      const elem = document.querySelector(".SbMessageLog .scroll_block")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },
  },
}
