import GeneralHelpModal from "./GeneralHelpModal.vue"

export const app_general_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        component: GeneralHelpModal,
        fullScreen: false,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
}
