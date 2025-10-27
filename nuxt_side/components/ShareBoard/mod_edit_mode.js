export const mod_edit_mode = {
  data() {
    return {
      edit_warn_modal_instance: null, // 「共有中の局面編集は危険」モーダルが起動していれば情報が入っている
    }
  },
  methods: {
    edit_warn_modal_handle() {
      if (this.edit_warn_modal_instance) {
        return
      }
      this.edit_warn_modal_instance = this.dialog_confirm({
        title: "共有中の局面編集は危険",
        message: `
          <div class="content">
            <ul class="mt-0 ml-5 is-size-7">
              <li>初期配置に戻したければここではなく<b>初期配置に戻す</b>をタップすべし</li>
              <li>局面編集すると編集後の局面を0手目とした棋譜になってしまう</li>
              <li>共有中の局面編集は変則的な配置で対局したいときだけ使うべし</li>
            </ul>
          </div>
        `,
        // <p class="is-size-7 has-text-grey">「待った」したいときは下のｺﾝﾄﾛｰﾗｰで少し前に戻って新しい手を指してください</p>
        confirmText: `理解した上で編集する`,
        focusOn: "cancel", // confirm or cancel
        type: "is-danger",
        hasIcon: false,
        onConfirm: () => {
          this.sfx_click()
          this.al_share({label: "局面編集前"})
          this.sp_mode = "edit"
          this.edit_warn_modal_close()
        },
        onCancel: () => {
          this.sfx_click()
          this.edit_warn_modal_close()
        },
      })
    },
    edit_warn_modal_close() {
      if (this.edit_warn_modal_instance) {
        this.edit_warn_modal_instance.close()
        this.edit_warn_modal_instance = null
      }
    },

    // 編集モード
    edit_mode_handle() {
      if (this.edit_warn_modal_instance) {
        return
      }
      this.sidebar_p = false
      this.sfx_click()
      if (this.ac_room) {
        this.edit_warn_modal_handle()
        return
      }
      this.edit_mode_sfen = null // 編集モードで動かしたらこれに入る
      this.sp_mode = "edit"
    },

    // 編集完了
    play_mode_handle() {
      this.sidebar_p = false
      this.sfx_click()
      // 編集モードの最後のSFENを play の sfen に戻す
      if (this.edit_mode_sfen) {
        this.current_sfen = this.edit_mode_sfen
        this.edit_mode_sfen = null

        this.honpu_main_setup()           // 読み込んだ棋譜を本譜とする
        this.honpu_share()             // それを他の人に共有する
      }
      this.sp_mode = "play"
      this.al_share({label: "局面編集後"})
      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.my_call_name}が局面を編集しました`))
      }
    },

    // 玉配置/玉回収
    king_formation_auto_set(v) {
      this.sfx_click()
      if (this.sp_king_formation_auto_set_on_off(v)) {
        this.sp_piece_box_piece_counts_adjust() // 玉が増える場合があるので駒箱を調整する
      } else {
        if (v) {
          this.toast_warn("配置する場所がありません")
        } else {
          this.toast_warn("回収するブロックがありません")
        }
      }
    },

    // 編集モードの棋譜をコピーする
    edit_mode_kifu_copy_handle() {
      if (this.edit_mode_sfen) {
        this.sidebar_p = false
        this.sfx_click()
        this.general_kifu_copy(this.edit_mode_sfen, {
          to_format: this.FormatTypeInfo.fetch("kif_utf8").format_key,
          turn: 0,
          title: this.current_title,
          ...this.player_names,
        })
      }
    },
  },
  computed: {
    // 編集モードの棋譜オブジェクト
    edit_mode_kifu_vo() {
      if (this.edit_mode_sfen) {
        return this.$KifuVo.create({
          sfen: this.edit_mode_sfen,
          turn: 0,
        })
      }
    },
  },
}
