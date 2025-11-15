import SbHelpModal from "./SbHelpModal.vue"

export const mod_help = {
  methods: {
    general_help_modal_open_handle() {
      this.sidebar_close()
      this.sfx_click()
      this.modal_card_open({
        component: SbHelpModal,
      })
    },
  },
}
