import _ from "lodash"
import dayjs from "dayjs"

const ACTION_LOG_MAX = 100
const ACTION_LOG_PUSH_TO = "top"

export const app_action_log = {
  data() {
    return {
      action_logs: [],
    }
  },
  methods: {
    al_add(params) {
      if (ACTION_LOG_PUSH_TO === "top") {
        this.action_logs.unshift(params)
        this.action_logs = _.take(this.action_logs, ACTION_LOG_MAX)
      } else {
        this.action_logs.push(params)
        this.action_logs = _.takeRight(this.action_logs, ACTION_LOG_MAX)
        this.al_scroll_to_bottom()
      }
    },
    al_add_test() {
      const i = this.base.action_logs.length
      this.al_add({
        from_user_name: "あいうえおあいうえお",
        lmi: {
          kif_without_from:    "☗7六歩",
          next_turn_offset:    i,
          player_location_key: "black",
          yomiage:             "ななろくふ",
        },
        sfen: "position startpos",
        turn_offset: i,
        last_location_key: "white",
        performed_at: this.time_current_ms(),
      })
    },
    al_scroll_to_bottom() {
      const e = this.$refs.ShareBoardActionLog
      if (e) {
        this.scroll_to_bottom(e.$refs.scroll_block)
      }
    },
  },
}
