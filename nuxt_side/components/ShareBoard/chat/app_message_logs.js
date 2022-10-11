// チャットの発言履歴

import _ from "lodash"
import dayjs from "dayjs"
const MD5 = require("md5.js")

const MESSAGE_LOG_MAX     = 100        // メッセージ履歴件数
const MESSAGE_LOG_PUSH_TO = "bottom"   // pushする方向

export const app_message_logs = {
  data() {
    return {
      message_logs: [],
    }
  },
  methods: {
    // 発言の追加
    ml_add(params) {
      params = {
        ...params,
        unique_key: this.ml_unique_key_generate(params),
      }
      if (MESSAGE_LOG_PUSH_TO === "top") {
        this.message_logs.unshift(params)
        this.message_logs = _.take(this.message_logs, MESSAGE_LOG_MAX)
      } else {
        this.message_logs.push(params)
        this.message_logs = _.takeRight(this.message_logs, MESSAGE_LOG_MAX)
        this.ml_scroll_to_bottom()
      }
    },

    // デバッグ用
    ml_add_test() {
      this.ml_add({
        from_user_name: "BOT",
        message: "aaa",
        performed_at: this.$time.current_ms(),
      })
    },

    ml_bot(message) {
      this.ml_add({
        from_user_name: "BOT",
        message: message,
        performed_at: this.$time.current_ms(),
      })
    },

    ml_unique_key_generate(params) {
      const str = [
        params.message,
        params.from_connection_id,
        params.performed_at,
      ].join("/")
      return new MD5().update(str).digest("hex")
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
