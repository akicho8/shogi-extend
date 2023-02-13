import { DebugModeInfo } from "./models/debug_mode_info.js"

export const app_debug = {
  methods: {
    // for autoexec
    debug_mode_on() { this.debug_mode_key = true },

    debug_mode_toggle() {
      this.debug_mode_p = !this.debug_mode_p
    },

    debug_mode_set_any(value = null) {
      if (this.present_p(value)) {
        this.debug_mode_p = value
      } else {
        this.debug_mode_toggle()
      }
    },

  },
  computed: {
    DebugModeInfo() { return DebugModeInfo },
    debug_mode_info() { return this.DebugModeInfo.fetch(this.debug_mode_key) },
    debug_mode_p: {
      get()  { return this.debug_mode_info.key },
      set(v) { this.debug_mode_key = this.str_to_boolean(v) },
    },
  },
}
