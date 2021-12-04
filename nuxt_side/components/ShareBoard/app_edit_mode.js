import AnySourceReadModal from "@/components/AnySourceReadModal.vue"

export const app_edit_mode = {
  methods: {
    edit_warn_modal_handle() {
      this.dialog_confirm({
        title: "共有中の局面編集は危険",
        message: `
          編集すると連続した指し手の棋譜ではなく編集後の局面を基点とした棋譜になってしまいます。
          基本的に共有中の局面編集は変則的な駒落ちで対戦するときの初期配置設定だけに使ってください。
        `,
        // <p class="is-size-7 has-text-grey">「待った」したいときは下のｺﾝﾄﾛｰﾗｰで少し前に戻って新しい手を指してください</p>
        confirmText: `理解した上で編集する`,
        focusOn: "cancel", // confirm or cancel
        type: "is-danger",
        hasIcon: true,
        onConfirm: () => {
          this.sound_play_click()
          this.shared_history_add({label: "局面編集前"})
          this.sp_run_mode = "edit_mode"
        },
      })
    },

    // 編集モード
    edit_mode_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      if (this.ac_room) {
        this.edit_warn_modal_handle()
        return
      }
      this.edit_mode_sfen = null // 編集モードで動かしたらこれに入る
      this.sp_run_mode = "edit_mode"
    },

    // 編集完了
    play_mode_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      // 編集モードの最後のSFENを play_mode の sfen に戻す
      if (this.edit_mode_sfen) {
        this.current_sfen = this.edit_mode_sfen
        this.edit_mode_sfen = null
      }
      this.sp_run_mode = "play_mode"
      this.shared_history_add({label: "局面編集後"})
      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.user_call_name(this.user_name)}が編集した局面を転送しました`))
      }
    },

    // 駒箱調整
    piece_box_piece_counts_adjust() {
      this.$refs.main_sp.sp_object().mediator.piece_box_piece_counts_adjust()
    },

    // 玉配置/玉回収
    king_formation_auto_set(v) {
      this.sound_play_click()
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
      this.sound_play_click()
      const modal_instance = this.modal_card_open({
        component: AnySourceReadModal,
        events: {
          "update:any_source": any_source => {
            this.$axios.$post("/api/general/any_source_to.json", {any_source: any_source, to_format: "sfen"}).then(e => {
              this.bs_error_message_dialog(e)
              if (e.body) {
                this.sound_play_click()
                this.toast_ok("棋譜を読み込みました")
                this.shared_history_add({label: "棋譜読込前"})
                this.current_sfen = e.body
                this.current_turn = e.turn_max // TODO: 最大手数ではなく KENTO URL から推測する default_sp_turn
                this.sp_viewpoint = "black"
                this.ac_log("棋譜読込", e.body)
                modal_instance.close()

                // すぐ実行すると棋譜読込前より先に記録される場合があるので遅らせる
                this.delay_block(0.1, () => this.shared_history_add({label: "棋譜読込後(本筋)"}))

                if (this.ac_room) {
                  this.delay_block(0.2, () => this.quick_sync(`${this.user_call_name(this.user_name)}が読み込んだ棋譜を転送しました。「局面の転送」は不要です`))
                }
              }
            })
          },
        },
      })
    },
  },
}
