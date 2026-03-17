import AppearanceModal from "./AppearanceModal.vue"

export const appearance_modal = {
  data() {
    return {
    }
  },

  beforeDestroy() {
    this.appearance_modal_close()
  },

  methods: {
    appearance_modal_open_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.appearance_modal_open()
      this.general_setting_modal_close()
    },

    appearance_modal_close_handle() {
      // this.sidebar_close()
      this.sfx_click()
      this.appearance_modal_close()
    },

    appearance_modal_open() {
      this.appearance_modal_close()
      this.appearance_modal_instance = this.modal_card_open({
        component: AppearanceModal,
        onCancel: () => {
          this.sfx_click()
          this.appearance_modal_close()
        },
      })
    },

    appearance_modal_close() {
      if (this.appearance_modal_instance) {
        this.appearance_modal_instance.close()
        this.appearance_modal_instance = null
      }
    },
  },
}
