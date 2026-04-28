import { GX } from "@/components/models/gx.js"
import { sb_shortcut_modal } from "./sb_shortcut_modal.js"
import { ShortcutInfo } from "./shortcut_info.js"

export const mod_shortcut = {
  mixins: [sb_shortcut_modal],

  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },

  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },

  methods: {
    keydown_handle(event) {
      if (this.$nuxt.isOffline) {
        return
      }
      if (this.DomHelper.focus_on_input_tag_p()) {
        return
      }
      const info = ShortcutInfo.values.find(info => {
        if (info.if_mode === "play" && !this.play_mode_p) {
          return
        }
        if (info.if_mode === "edit" && !this.edit_mode_p) {
          return
        }
        if (info.if_debug && !this.debug_mode_p) {
          return
        }
        if (info.kb_key) {
          if (!GX.ary_wrap(info.kb_key).some(key => this.KeyboardHelper.soft_pure_key_p(event, key))) {
            return
          }
        }
        if (info.kb_code) {
          if (!GX.ary_wrap(info.kb_code).some(code => this.KeyboardHelper.pure_code_p(event, code))) {
            return
          }
        }
        return true
      })
      if (!info) {
        return
      }
      this[info.key]()
      event.preventDefault()
    },
  },
}
