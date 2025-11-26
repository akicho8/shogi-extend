export const mod_edit_mode = {
  data() {
    return {
      edit_warn_modal_instance: null, // 「共有中の局面編集は危険」モーダルが起動していれば情報が入っている
    }
  },
  methods: {
    edit_warn_modal_open() {
      if (this.edit_warn_modal_instance) {
        return
      }
      this.edit_warn_modal_instance = this.dialog_confirm({
        title: "共有中の局面編集は危険です",
        message: [
          `<div class="content">`,
            `<p>もしかして1手戻したいだけ？ それならメニューから<b>1手戻す</b>を選択しよう</p>`,
            `<p>局面編集すると、現時点までの棋譜を破棄し、編集後の局面を0手目とした棋譜になる</p>`,
            `<p>共有中の局面編集は、手合割にない変則的な配置から対局したいときだけ使おう</p>`,
          `</div>`,
        ].join(""),
        confirmText: `理解した上で編集する`,
        focusOn: "cancel", // confirm or cancel
        type: "is-danger",
        hasIcon: true,
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
    edit_mode_set_handle() {
      if (this.edit_warn_modal_instance) {
        return
      }
      this.sidebar_close()
      this.sfx_click()
      if (this.ac_room) {
        this.edit_warn_modal_open()
        return
      }
      this.edit_mode_sfen = null // 編集モードで動かしたらこれに入る
      this.sp_mode = "edit"
    },

    // 編集完了
    play_mode_set_handle() {
      this.sidebar_close()
      this.sfx_click()
      // 編集モードの最後のSFENを play の sfen に戻す
      if (this.edit_mode_sfen) {
        this.current_sfen_set(this.edit_mode_kifu_vo.sfen_and_turn)
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
        this.sidebar_close()
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

    tweet_button_type() {
      if (this.SB.advanced_p) {
        return "is-twitter"
      }
    },
  },
}
