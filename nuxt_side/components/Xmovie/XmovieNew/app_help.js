import XmovieNewHelpModal from "./XmovieNewHelpModal.vue"

export const app_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: XmovieNewHelpModal,
        props: { base: this.base },
      })
    },
  },
}
