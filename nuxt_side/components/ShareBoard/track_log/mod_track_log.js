import { GX } from "@/components/models/gx.js"
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
      tl_modal_instance: null,
    }
  },
  mounted() {
    if (this.development_p && false) {
      for (let i = 0; i < 50; i++) {
        this.tl_add("TEST", `${i}`)
      }
    }
  },
  beforeDestroy() {
    this.tl_modal_close()
  },
  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    tl_modal_open_handle() {
      if (!this.tl_modal_instance) {
        this.sfx_click()
        this.tl_modal_open()
      }
    },
    tl_modal_open() {
      if (!this.tl_modal_instance) {
        // https://buefy.org/documentation/modal
        this.tl_modal_instance = this.modal_card_open({
          component: TrackLogModal,
          fullScreen: true,
          onCancel: () => {
            this.sfx_click()
            this.tl_modal_close()
          },
        })
      }
    },
    tl_modal_close_handle() {
      if (this.tl_modal_instance) {
        this.sfx_click()
        this.tl_modal_close()
      }
    },
    tl_modal_close() {
      if (this.tl_modal_instance) {
        this.tl_modal_instance.close()
        this.tl_modal_instance = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    tl_clear() {
      this.track_logs = []
    },
    tl_test() {
      this.tl_add("(test)", `message${this.track_logs.length}`)
    },
    tl_alert(message, detail_info = null) {
      if (this.production_p) { return }
      if (GX.blank_p(message)) { return }
      if (this.__SYSTEM_TEST_RUNNING__) {
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
    tl_p(message, detail_info = null) {
      this.tl_add("", message, detail_info)
    },
    tl_scroll_to_bottom() {
      this.scroll_to_bottom(document.querySelector(".TrackLogModal .modal-card-body"))
    },
  },
}
