import AppearanceModal from "./AppearanceModal.vue"

export const appearance_modal = {
  beforeDestroy() {
    this.appearance_modal_close()
  },

  methods: {
    appearance_modal_toggle_handle() {
      if (this.appearance_modal_instance) {
        this.appearance_modal_close_handle()
      } else {
        this.appearance_modal_open_handle()
      }
    },

    appearance_modal_open_handle() {
      if (!this.appearance_modal_instance) {
        this.sfx_click()
        this.appearance_modal_open()
      }
    },

    appearance_modal_open() {
      if (!this.appearance_modal_instance) {
        this.modal_card_open2("appearance_modal_instance", {
          component: AppearanceModal,
          onCancel: () => {
            this.sfx_click()
            this.appearance_modal_close()
          },
        })
      }
    },

    appearance_modal_close_handle() {
      if (this.appearance_modal_instance) {
        this.sfx_click()
        this.appearance_modal_close()
      }
    },

    appearance_modal_close() {
      if (this.appearance_modal_instance) {
        this.modal_card_close2("appearance_modal_instance")
      }
    },
  },
}
