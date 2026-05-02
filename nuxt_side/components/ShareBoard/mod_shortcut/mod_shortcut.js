import { GX } from "@/components/models/gx.js"
import { sb_shortcut_modal } from "./sb_shortcut_modal.js"
import { ShortcutInfo } from "./shortcut_info.js"
import { ShortcutCategoryInfo } from "./shortcut_category_info.js"

export const mod_shortcut = {
  mixins: [
    sb_shortcut_modal,
  ],

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
      if (this.DomHelper.input_focused_p()) {
        return
      }
      const info = ShortcutInfo.values.find(e => e.match_p(this, event))
      if (!info) {
        return
      }
      this[info.method]()
      event.preventDefault()
    },
  },

  computed: {
    ShortcutInfo()         { return ShortcutInfo         },
    ShortcutCategoryInfo() { return ShortcutCategoryInfo },
  },
}
