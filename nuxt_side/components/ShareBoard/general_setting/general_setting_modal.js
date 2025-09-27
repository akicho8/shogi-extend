import GeneralSettingModal from "./GeneralSettingModal.vue"

export const general_setting_modal = {
  data() {
    return {
      general_setting_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.general_setting_modal_close()
  },

  methods: {
    general_setting_modal_shortcut_handle() {
      if (this.general_setting_modal_instance == null) {
        this.general_setting_modal_open_handle()
      } else {
        this.general_setting_modal_close_handle()
      }
      return true
    },

    general_setting_modal_open_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.general_setting_modal_open()
    },

    general_setting_modal_close_handle() {
      this.sidebar_p = false
      this.sfx_play_click()
      this.general_setting_modal_close()
    },

    general_setting_modal_open() {
      this.general_setting_modal_close()
      this.general_setting_modal_instance = this.modal_card_open({
        component: GeneralSettingModal,
        onCancel: () => {
          this.sfx_play_click()
          this.general_setting_modal_close()
        },
      })
    },

    general_setting_modal_close() {
      if (this.general_setting_modal_instance) {
        this.general_setting_modal_instance.close()
        this.general_setting_modal_instance = null
      }
    },
  },
}
