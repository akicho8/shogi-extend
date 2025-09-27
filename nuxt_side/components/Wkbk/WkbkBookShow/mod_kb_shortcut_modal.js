import WkbkBookShowKbShortcutModal from "./WkbkBookShowKbShortcutModal.vue"

export const mod_kb_shortcut_modal = {
  data() {
    return {
      kb_shortcut_modal_p: false,
    }
  },
  methods: {
    kb_shortcut_modal_shortcut_handle() {
      if (this.kb_shortcut_modal_active_p()) {
        this.kb_shortcut_modal_close()
      } else {
        this.kb_shortcut_modal_show()
      }
    },
    kb_shortcut_modal_show() {
      this.sfx_play_click()
      this.kb_shortcut_modal_close()
      if (this.$kb_shortcut_modal) { alert("this.$kb_shortcut_modal") }
      this.$kb_shortcut_modal = this.modal_card_open({
        component: WkbkBookShowKbShortcutModal,
        props: { base: this.base },
        onCancel: () => { this.kb_shortcut_modal_close() },
      })
      this.kb_shortcut_modal_p = true

      // if (!this.sidebar_p) {
      //   this.interval_counter_pause(this.$kb_shortcut_modal)
      // }
    },
    kb_shortcut_modal_close() {
      if (this.$kb_shortcut_modal) {
        this.sfx_play_click()
        this.$kb_shortcut_modal.close()
        this.$kb_shortcut_modal = null
        this.kb_shortcut_modal_p = false
        // if (!this.sidebar_p) {
        //   this.interval_counter_pause(this.$kb_shortcut_modal)
        // }
      }
    },
    kb_shortcut_modal_active_p() {
      return !!this.$kb_shortcut_modal
    },
  },
}
