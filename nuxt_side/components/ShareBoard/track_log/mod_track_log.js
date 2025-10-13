import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
import dayjs from "dayjs"
import TrackLogModal from "./TrackLogModal.vue"

const TRACK_LOG_MAX     = 100
const TRACK_LOG_PUSH_TO = "bottom"

export const mod_track_log = {
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
      this.sfx_click()
      // https://buefy.org/documentation/modal
      this.modal_card_open({
        component: TrackLogModal,
        fullScreen: true,
      })
    },
    tl_clear() {
      this.track_logs = []
    },
    tl_test() {
      this.tl_add("(test)", `message${this.track_logs.length}`)
    },
    tl_alert(message, detail_info = null) {
      if (this.production_p) { return }
      if (Gs.blank_p(message)) { return }
      if (this.__system_test_now__) {
      } else {
        this.debug_alert_core(message)
      }
      this.tl_add("ALERT", message, detail_info)
    },
    tl_add(section, message, detail_info = null) {
      if (this.production_p) { return }
      const params = {
        id: this.track_logs_id,
        created_at: this.$time.current_ms(),
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
        if (false) {
          this.$nextTick(() => this.tl_scroll_to_bottom())
        }
      }
    },
    tl_puts(message, detail_info = null) {
      this.tl_add("", message, detail_info)
    },
    tl_scroll_to_bottom() {
      this.scroll_to_bottom(document.querySelector(".TrackLogModal .modal-card-body"))
    },
  },
}
