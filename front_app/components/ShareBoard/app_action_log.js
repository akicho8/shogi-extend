import _ from "lodash"

const ACTION_LOG_MAX = 100

export const app_action_log = {
  data() {
    return {
      action_logs: [],
    }
  },
  methods: {
    al_push(params) {
      this.action_logs.push(params)
      this.action_logs = _.takeRight(this.action_logs, ACTION_LOG_MAX)
      this.al_scroll_to_bottom()
    },
    al_push_test() {
      this.al_push({turn_offset: this.base.action_logs.length, from_user_name: "あいうえおあいうえお", sfen: "position startpos"})
    },
    al_scroll_to_bottom() {
      const e = this.$refs.ShareBoardActionLog
      if (e) {
        this.scroll_to_bottom(e.$refs.foobar)
      }
    },
  },
}
