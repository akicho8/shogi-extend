import WkbkBookShowKbShortcutModal from "./WkbkBookShowKbShortcutModal.vue"

export const app_kb_shortcut_modal = {
  data() {
    return {
      kb_shortcut_modal_p: false,
    }
  },
  methods: {
    kb_shortcut_modal_toggle_handle() {
      if (this.kb_shortcut_modal_active_p()) {
        this.kb_shortcut_modal_close()
      } else {
        this.kb_shortcut_modal_show()
      }
    },
    kb_shortcut_modal_show() {
      this.sound_play("click")
      this.kb_shortcut_modal_close()
      if (this.$kb_shortcut_modal) { alert("this.$kb_shortcut_modal") }
      this.$kb_shortcut_modal = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        props: { base: this.base },
        animation: "",
        onCancel: () => { this.kb_shortcut_modal_close() },
        canCancel: ["escape", "outside"],
        component: WkbkBookShowKbShortcutModal,
        // events: {
        //   "close": () => { alert("x") },
        // },
      })
      this.kb_shortcut_modal_p = true

      // if (!this.sidebar_p) {
      //   this.interval_counter_pause(this.$kb_shortcut_modal)
      // }
    },
    kb_shortcut_modal_close() {
      if (this.$kb_shortcut_modal) {
        this.sound_play("click")
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
