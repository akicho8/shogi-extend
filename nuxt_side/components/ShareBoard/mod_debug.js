import { DebugModeInfo } from "./models/debug_mode_info.js"

export const mod_debug = {
  methods: {
    // for autoexec
    is_debug_mode_on() { this.debug_mode_key = "is_debug_mode_on" },

    debug_mode_toggle() {
      this.debug_mode_p = !this.debug_mode_p
    },

    debug_mode_set_any(value = null) {
      if (this.$gs.present_p(value)) {
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
      get()  { return this.debug_mode_info.key === "is_debug_mode_on"                                  },
      set(v) { this.debug_mode_key = this.$gs.str_to_boolean(v) ? "is_debug_mode_on" : "is_debug_mode_off" },
    },
  },
}
