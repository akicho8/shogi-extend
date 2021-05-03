import _ from "lodash"
import dayjs from "dayjs"

const MESSAGE_LOG_MAX = 100
const MESSAGE_LOG_PUSH_TO = "bottom"

export const app_message_logs = {
  data() {
    return {
      message_logs: [],
    }
  },
  methods: {
    ml_add(params) {
      if (MESSAGE_LOG_PUSH_TO === "top") {
        this.message_logs.unshift(params)
        this.message_logs = _.take(this.message_logs, MESSAGE_LOG_MAX)
      } else {
        this.message_logs.push(params)
        this.message_logs = _.takeRight(this.message_logs, MESSAGE_LOG_MAX)
        this.ml_scroll_to_bottom()
      }
    },
    ml_add_test() {
      this.ml_add({
        from_user_name: "alice",
        from_user_code: this.message_logs.length,
        message: this.message_logs.length.toString(),
        performed_at: dayjs().valueOf(),
      })
    },
    ml_scroll_to_bottom() {
      const elem = document.querySelector(".ShareBoardMessageLogs .scroll_block")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },
  },
}
