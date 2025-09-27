import { DebugModeInfo } from "./models/debug_mode_info.js"
import { Gs } from "@/components/models/gs.js"

export const mod_debug = {
  methods: {
    // for autoexec
    debug_mode_on() { this.debug_mode_key = "on" },

    // for console
    debug_mode_set_any(value = null) {
      if (Gs.present_p(value)) {
        this.debug_mode_p = value
      } else {
        this.debug_mode_toggle()
      }
    },

    debug_mode_toggle() {
      this.debug_mode_p = !this.debug_mode_p
    },
  },
  computed: {
    DebugModeInfo() { return DebugModeInfo },
    debug_mode_info() { return this.DebugModeInfo.fetch(this.debug_mode_key) },
    debug_mode_p: {
      get()  { return this.debug_mode_info.key === "on"                  },
      set(v) { this.debug_mode_key = Gs.str_to_boolean(v) ? "on" : "off" },
    },
  },
}
