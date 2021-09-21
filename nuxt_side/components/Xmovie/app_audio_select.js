import AudioSelectModal from "./AudioSelectModal.vue"

export const app_audio_select = {
  methods: {
    audio_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        width: "", // width ではなく max-width に設定される
        customClass: "BasicModal AudioSelectModal",
        component: AudioSelectModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: ["outside", "escape"],
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
