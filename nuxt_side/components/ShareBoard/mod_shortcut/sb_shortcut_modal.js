import SbShortcutModal from "./SbShortcutModal.vue"

export const sb_shortcut_modal = {
  beforeDestroy() {
    this.shortcut_modal_close()
  },

  methods: {
    shortcut_modal_toggle_handle() {
      if (!this.shortcut_modal_instance) {
        this.shortcut_modal_open_handle()
      } else {
        this.shortcut_modal_close_handle()
      }
      return true
    },

    shortcut_modal_open_handle() {
      if (!this.shortcut_modal_instance) {
        this.sfx_click()
        this.shortcut_modal_open()
      }
    },

    shortcut_modal_close_handle() {
      if (this.shortcut_modal_instance) {
        this.sfx_click()
        this.shortcut_modal_close()
      }
    },

    shortcut_modal_open() {
      this.shortcut_modal_close()
      this.modal_card_open2("shortcut_modal_instance", {
        component: SbShortcutModal,
        onCancel: () => {
          this.sfx_click()
          this.shortcut_modal_close()
        },
      })
    },

    shortcut_modal_close() {
      if (this.shortcut_modal_instance) {
        this.modal_card_close2("shortcut_modal_instance")
      }
    },
  },
}
