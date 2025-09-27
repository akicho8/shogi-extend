import SoundResumeModal from "./SoundResumeModal.vue"

export const mod_sound_resume = {
  data() {
    return {
      sound_resume_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.sound_resume_modal_close()
  },

  methods: {
    sound_resume_modal_handle() {
      this.sound_resume_modal_close()
      this.sound_resume_modal_instance = this.$buefy.modal.open({
        component: SoundResumeModal,
        customClass: "SoundResumeModal",
        parent: this,
        animation: "",
        canCancel: ["outside"],
        onCancel: () => {
          this.sound_resume_all_with_click()
        },
        events: {
          close: () => {
            this.sound_resume_all_with_click()
          },
        },
      })
    },

    sound_resume_modal_close() {
      if (this.sound_resume_modal_instance) {
        this.sound_resume_modal_instance.close()
        this.sound_resume_modal_instance = null
      }
    },

    sound_resume_alert_handle() {
      this.dialog_alert({
        title: "",
        message: "復帰しますか？",
        onConfirm: () => {
          this.sound_resume_all_with_click()
        },
      })
    },

    sound_resume_all_with_click() {
      this.sfx_resume_all()    // Howler.unload() の実行
      this.sfx_play_click()    // Howler.unload() が正しく作動すればここで音が出る
    },

    sound_resume_all_with_rooster() {
      this.sfx_resume_all()
      this.sfx_play("se_niwatori")
    },
  },
}
