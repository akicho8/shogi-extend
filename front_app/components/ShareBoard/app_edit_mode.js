export const app_edit_mode = {
  data() {
    return {
    }
  },
  mounted() {
  },
  beforeDestroy() {
  },
  methods: {
    edit_warn_modal_handle() {
      this.$buefy.dialog.confirm({
        title: "共有中の局面編集は危険",
        message: `編集するとこれまでの棋譜が消えます<p>駒落ちで対戦するときなどだけに使ってください</p><p class="is-size-7 has-text-grey">「待った」する場合は下のｺﾝﾄﾛｰﾗｰで少し前に戻って新しい手を指してください</span>`,
        cancelText: "キャンセル",
        confirmText: `理解した上で編集する`,
        focusOn: "cancel", // confirm or cancel
        type: "is-danger",
        hasIcon: true,
        animation: "",
        onCancel:  () => {
          this.talk_stop()
          this.sound_play("click")
        },
        onConfirm: () => {
          this.talk_stop()
          this.sp_run_mode = "edit_mode"
        },
      })
    },

    // 編集モード
    edit_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      if (this.share_p) {
        this.edit_warn_modal_handle()
      } else {
        this.sp_run_mode = "edit_mode"
      }
    },

    // 編集完了
    play_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.sp_run_mode = "play_mode"
    },

  },
}
