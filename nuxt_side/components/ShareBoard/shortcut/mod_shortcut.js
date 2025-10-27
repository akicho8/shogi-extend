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
      if (this.focus_on_input_tag_p()) {
        this.tl_add("SHORTCUT", "INPUTタグにフォーカスされていたのでキャンセルする", e)
        return
      }
      const found = ShortcutInfo.values.find(o => o._if(this, e))
      if (!found) {
        this.tl_add("SHORTCUT", "対応する命令が見つからない", e)
        return
      }
      this.tl_add("SHORTCUT", "対応する命令が見つかったので実行する", e)
      if (found.call(this)) {
        this.tl_add("SHORTCUT", "戻値 true")
      } else {
        this.tl_add("SHORTCUT", "戻値 false")
      }
      e.preventDefault()
    },
  },
}
