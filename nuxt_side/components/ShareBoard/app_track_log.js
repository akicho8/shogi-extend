import _ from "lodash"
import dayjs from "dayjs"
import TrackLogModal from "./TrackLogModal.vue"

const TRACK_LOG_MAX     = 100
const TRACK_LOG_PUSH_TO = "bottom"

export const app_track_log = {
  data() {
    return {
      track_logs: [],
      track_logs_id: 0,
    }
  },
  mounted() {
    if (this.development_p && false) {
      for (let i = 0; i < 50; i++) {
        this.tl_add("TEST", `${i}`)
      }
    }
  },
  methods: {
    tl_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: TrackLogModal,
        props: { base: this.base },
      })
    },
    tl_clear() {
      this.track_logs = []
    },
    tl_test() {
      this.tl_add("(test)", `message${this.track_logs.length}`)
    },
    tl_alert(message) {
      if (this.debug_mode_p && this.present_p(message)) {
        this.debug_alert_core(message)
        this.tl_add("ALERT", message)
      }
    },
    tl_add(section, message, detail_info = null) {
      if (!this.debug_mode_p) {
        return
      }
      const params = {
        id: this.track_logs_id,
        created_at: this.time_current_ms(),
        section,
        message,
        detail_info,
      }
      this.track_logs_id += 1
      if (TRACK_LOG_PUSH_TO === "top") {
        this.track_logs.unshift(params)
        this.track_logs = _.take(this.track_logs, TRACK_LOG_MAX)
      } else {
        this.track_logs.push(params)
        this.track_logs = _.takeRight(this.track_logs, TRACK_LOG_MAX)
        this.tl_scroll_to_bottom()
      }
    },
    tl_scroll_to_bottom() {
      const elem = document.querySelector(".TrackLogModal .modal-card-body")
      if (elem) {
        this.scroll_to_bottom(elem)
      }
    },
  },
}
