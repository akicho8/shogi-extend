import SwShortcutModal from "./SwShortcutModal.vue"

export const sw_shortcut_modal = {
  data() {
    return {
      _shortcut_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.shortcut_modal_close()
  },

  methods: {
    shortcut_modal_shortcut_handle() {
      if (this._shortcut_modal_instance == null) {
        this.shortcut_modal_open_handle()
      } else {
        this.shortcut_modal_close_handle()
      }
      return true
    },

    shortcut_modal_open_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.shortcut_modal_open()
    },

    shortcut_modal_close_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.shortcut_modal_close()
    },

    shortcut_modal_open() {
      this.shortcut_modal_close()
      this._shortcut_modal_instance = this.modal_card_open({
        component: SwShortcutModal,
        onCancel: () => {
          this.sfx_play_click()
          this.shortcut_modal_close()
        },
      })
    },

    shortcut_modal_close() {
      if (this._shortcut_modal_instance) {
        this._shortcut_modal_instance.close()
        this._shortcut_modal_instance = null
      }
    },
  },
}
