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
    keydown_handle(e) {
      if (this.$nuxt.isOffline) {
        return
      }
      if (this.focus_on_input_tag_p()) {
        return
      }
      const info = ShortcutInfo.values.find(o => o._if(this, e))
      if (!info) {
        return
      }
      info.call(this)
      e.preventDefault()
    },
  },
}
