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
        return
      }
      const found = ShortcutInfo.values.find(o => {
        if (o.input_key) {
          return e.key === o.input_key
        }
      })
      if (found) {
        if (found.call(this)) {
          e.preventDefault()
        }
      }

      {
        let processed = false

        // if (e.key === "?") {
        //   processed = this.shortcut_modal_shortcut_handle()
        // }

        if (this.keyboard_single_code_equal(e, "Space")) {
          processed = this.chat_modal_shortcut_handle()
        }

        if (this.keyboard_single_key_equal(e, "r")) {
          processed = this.room_setup_modal_toggle_handle()
        }

        if (this.keyboard_single_key_equal(e, "o")) {
          processed = this.os_modal_shortcut_handle()
        }

        if (this.keyboard_single_key_equal(e, "t") || this.keyboard_single_key_equal(e, "c")) {
          processed = this.cc_modal_shortcut_handle()
        }

        if (e.code === "KeyC" && this.keyboard_meta_without_shift_p(e)) {
          this.kifu_copy_handle("kif_utf8")
          processed = true
        }

        if (e.code === "KeyV" && this.keyboard_meta_without_shift_p(e)) {
          processed = this.yomikomi_from_clipboard()
        }

        if (processed) {
          e.preventDefault()
        }
      }
    },
  },
}
