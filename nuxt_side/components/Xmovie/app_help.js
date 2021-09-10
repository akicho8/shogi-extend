import XmovieHelpModal from "./XmovieHelpModal.vue"

export const app_help = {
  methods: {
    general_help_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "XmovieHelpModal",
        component: XmovieHelpModal,
        fullScreen: false,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["escape", "outside"],
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
