import AudioSelectModal from "./AudioSelectModal.vue"

export const app_audio_select = {
  methods: {
    audio_select_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.modal_card_open({
        component: AudioSelectModal,
        props: { base: this.base },
      })
    },
  },
}
