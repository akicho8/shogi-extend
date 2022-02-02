import SoundResumeModal from "./SoundResumeModal.vue"

export const app_sound_resume = {
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
        props: { base: this.base },
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
      this.sp_sound_resume_all() // Howler.unload() の実行 (shogi-player 側) なんでこれもいる？？？
      this.sound_resume_all()    // Howler.unload() の実行
      this.sound_play_click()    // Howler.unload() が正しく作動すればここで音が出る
      // this.delay_block(0.5, () => this.talk("もどりました"))
    },
  },
}
