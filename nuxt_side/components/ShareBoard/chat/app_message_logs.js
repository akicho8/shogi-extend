// チャットの発言履歴

import _ from "lodash"
import dayjs from "dayjs"
import { Xmessage } from "./xmessage.js"

export const app_message_logs = {
  data() {
    return {
      message_logs: [],
    }
  },
  methods: {
    // 発言の追加
    ml_add(params) {
      this.ml_add_xmessage(Xmessage.create(params))
    },

    ml_add_xmessage(xmessage) {
      this.message_logs.push(xmessage)
      this.message_logs = _.takeRight(this.message_logs, this.AppConfig.CHAT_MESSAGES_SIZE_MAX)
      this.ml_scroll_to_bottom()
    },

    // デバッグ用
    ml_test() {
      this.local_bot_say("OK")
    },

    local_bot_say(message) {
      this.ml_add({from_user_name: "Bot", message: message})
    },

    // 一番下までスクロール
    ml_scroll_to_bottom() {
      const elem = document.querySelector(".ShareBoardMessageLog .scroll_block")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },
  },
}
