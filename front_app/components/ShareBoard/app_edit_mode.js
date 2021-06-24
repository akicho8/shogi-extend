import AnySourceReadModal from "@/components/AnySourceReadModal.vue"

export const app_edit_mode = {
  methods: {
    edit_warn_modal_handle() {
      // this.toast_warn("「待った」したいときは下のｺﾝﾄﾛｰﾗｰで少し前に戻って新しい手を指してください")
      this.$buefy.dialog.confirm({
        title: "共有中の局面編集は危険",
        message: `
          編集するとこれまでの棋譜が消えてしまいます。
          基本的に共有中の局面編集は特殊な駒落ちなどで対戦するときの初期配置設定だけに使ってください。
        `,
        // <p class="is-size-7 has-text-grey">「待った」したいときは下のｺﾝﾄﾛｰﾗｰで少し前に戻って新しい手を指してください</p>
        cancelText: "キャンセル",
        confirmText: `理解した上で編集する`,
        focusOn: "cancel", // confirm or cancel
        type: "is-danger",
        hasIcon: true,
        animation: "",
        onCancel:  () => {
          this.sound_stop_all()
          this.sound_play("click")
        },
        onConfirm: () => {
          this.sound_stop_all()
          this.sound_play("click")
          this.al_add({label: "局面編集前"})
          this.sp_run_mode = "edit_mode"
        },
      })
    },

    // 編集モード
    edit_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      if (this.ac_room) {
        this.edit_warn_modal_handle()
        return
      }
      this.sp_run_mode = "edit_mode"
    },

    // 編集完了
    play_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.sp_run_mode = "play_mode"
      this.al_add({label: "局面編集後"})
    },

    // 駒箱調整
    piece_box_piece_counts_adjust() {
      this.$refs.main_sp.sp_object().mediator.piece_box_piece_counts_adjust()
    },

    // 玉配置/玉回収
    king_formation_auto_set(v) {
      this.sound_play("click")
      if (this.$refs.main_sp.sp_object().mediator.king_formation_auto_set_on_off(v)) {
        this.piece_box_piece_counts_adjust() // 玉が増える場合があるので駒箱を調整する
      } else {
        if (v) {
          this.toast_warn("配置する場所がありません")
        } else {
          this.toast_warn("回収するブロックがありません")
        }
      }
    },

    // 棋譜の読み込みタップ時の処理
    any_source_read_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      const modal_instance = this.$buefy.modal.open({
        parent: this,
        hasModalCard: true,
        animation: "",
        component: AnySourceReadModal,
        onCancel: () => this.sound_play("click"),
        events: {
          "update:any_source": any_source => {
            this.$axios.$post("/api/general/any_source_to.json", {any_source: any_source, to_format: "sfen"}).then(e => {
              if (e.bs_error) {
                this.bs_error_message_dialog(e.bs_error)
              }
              if (e.body) {
                this.sound_play("click")
                this.toast_ok("棋譜を読み込みました")
                this.al_add({label: "棋譜読込前"})
                this.current_sfen = e.body
                this.turn_offset = e.turn_max // TODO: 最大手数ではなく KENTO URL から推測する default_sp_turn
                this.al_add({label: "棋譜読込後"})
                this.sp_viewpoint = "black"
                this.ac_log("棋譜読込", e.body)
                modal_instance.close()
              }
            })
          },
        },
      })
    },
  },
}
