import SbAudioUnlockModal from "./SbAudioUnlockModal.vue"

export const sb_audio_unlock_modal = {
  data() {
    return {
      audio_unlock_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.audio_unlock_modal_close()
  },

  methods: {
    audio_unlock_modal_open() {
      this.audio_unlock_modal_close()
      this.audio_unlock_modal_instance = this.$buefy.modal.open({
        component: SbAudioUnlockModal,
        customClass: "SbAudioUnlockModal",
        parent: this,
        animation: "",
        canCancel: ["outside"],
        onCancel: () => {
          this.audio_unlock_all_with_click()
        },
        events: {
          close: () => {
            this.audio_unlock_all_with_click()
          },
        },
      })
    },

    audio_unlock_modal_close() {
      if (this.audio_unlock_modal_instance) {
        this.audio_unlock_modal_instance.close()
        this.audio_unlock_modal_instance = null
      }
    },

    audio_unlock_alert_handle() {
      this.dialog_alert({
        title: "",
        message: "復帰しますか？",
        onConfirm: () => {
          this.audio_unlock_all_with_click()
        },
      })
    },

    audio_unlock_all_with_click() {
      this.sfx_resume_all() // Howler.unload() の実行
      this.sfx_click()      // Howler.unload() が正しく作動すればここで音が出る
    },

    audio_unlock_all_with_rooster() {
      this.sfx_resume_all()
      this.sfx_play("se_niwatori")
    },
  },
}
