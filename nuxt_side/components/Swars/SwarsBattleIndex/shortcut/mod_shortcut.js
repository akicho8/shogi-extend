import { sw_shortcut_modal } from "./sw_shortcut_modal.js"
import { ShortcutInfo } from "./shortcut_info.js"

export const mod_shortcut = {
  mixins: [sw_shortcut_modal],
  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },
  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },
  methods: {
    keydown_handle(e) {
      if (this.focus_on_input_tag_p()) {
        return
      }
      const found = ShortcutInfo.values.find(o => o._if(this, e))
      if (found) {
        if (found.call(this)) {
          e.preventDefault()
        }
      }
    },
  },
}
