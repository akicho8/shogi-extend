const DEBOUNCE_DELAY = 1000 * 1.0   // 1秒後に反映

import _ from "lodash"

export const app_sp = {
  methods: {
    // internal_rule_input_handle() {
    //   this.sound_play_click()
    // },

    // 再生モードで指したときmovesあり棋譜(URLに反映する)
    // 局面0で1手指したとき last_move_info.next_turn_offset は 1
    play_mode_advanced_full_moves_sfen_set(e) {
      this.current_sfen = e.sfen

      // this.sound_play("shout_08")
      // this.vibrate(10)

      // 時計があれば操作した側のボタンを押す
      // last_move_info.player_location なら指した人の色で判定
      // last_move_info.to_location なら駒の色で判定
      if (this.clock_box) {
        this.clock_box.tap_on(e.last_move_info.player_location)
      }

      this.sfen_share_params_set(e) // 再送可能なパラメータ作成
      this.sfen_share()             // 指し手と時計状態の配信

      // 次の人の視点にする
      if (false) {
        const location = this.current_sfen_info.location_by_offset(e.last_move_info.next_turn_offset)
        this.sp_viewpoint = location.key
      }
    },

    // デバッグ用
    mediator_snapshot_sfen_set(sfen) {
      if (this.development_p) {
        // this.$buefy.toast.open({message: `mediator_snapshot_sfen -> ${sfen}`, queue: false})
      }
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_sfen に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうから
    edit_mode_snapshot_sfen_set(v) {
      this.__assert__(this.sp_run_mode === "edit_mode", 'this.sp_run_mode === "edit_mode"')

      // NOTE: current_sfen に設定すると(current_sfenは駒箱を持っていないため)駒箱が消える
      // edit_modeの完了後に edit_mode_sfen を current_sfen に戻す
      this.edit_mode_sfen = v

      // 意図せず共有してしまうのを防ぐため共有しない
      // if (false) {
      //   this.sfen_share_params_set()
      // }
      // }
    },

    // ユーザーがコントローラやスライダーで操作し終わったら転送する
    sp_turn_user_changed: _.debounce(function(v) {
      if (this.ac_room) {
        this.$nextTick(() => this.quick_sync(`${this.user_call_name(this.user_name)}が${v}手目に変更しました`, {silent_notify: true}))
      }
    }, DEBOUNCE_DELAY),

    // private

    // url_replace() {
    //   this.$router.replace({query: this.current_url_params})
    // },

    // 手番が違うのに操作しようとした
    operation_invalid1_handle() {
      this.debug_alert("手番が違うのに操作しようとした")
      if (this.order_enable_p) {
        this.sound_play("x")
        const messages = []
        const name = this.current_turn_user_name
        if (name) {
          messages.push(`今は${this.user_call_name(name)}の手番です`)
          if (this.self_is_watcher_p) {
            messages.push(`あなたは観戦者なので操作できません`)
          }
          if (this.clock_box && this.clock_box.working_p) {
            // 対局中と思われる
          } else {
            // 時計OFFか時計停止中なので対局が終わっていると思われる (が、順番設定を解除していない)
            messages.push(`検討する場合は順番設定を解除してください`)
          }
        } else {
          messages.push(`順番設定で対局者の指定がないので誰も操作できません`)
        }
        if (this.present_p(messages)) {
          const full_message = messages.join("。")
          this.toast_ok(full_message)
          this.tl_add("OPVALID", `(${full_message})`)
        }
      }
    },

    // 自分が手番だが相手の駒を動かそうとした
    operation_invalid2_handle() {
      this.debug_alert("自分が手番だが相手の駒を動かそうとした")
      this.sound_play("x")
      this.toast_ok("それは相手の駒です")
    },

    foul_two_pawn_handle() {
      this.sound_play("x")
      this.toast_ng("二歩")
    },

    foul_piece_warp_handle(soldier) {
      this.sound_play("x")
      this.toast_ng(`${soldier.name}ワープ`)
    },

    foul_death_king_handle() {
      this.sound_play("x")
      this.toast_ng("王手放置")
    },

    // ShogiPlayer コンポーネント自体を実行したいとき用
    sp_call(func) {
      return func(this.$refs.ShareBoardSp.$refs.main_sp.sp_object())
    },

    // 持駒を元に戻す(デバッグ用)
    sp_state_reset() {
      return this.sp_call(e => e.state_reset())
    },

    // 駒箱調整
    sp_piece_box_piece_counts_adjust() {
      return this.sp_call(e => e.mediator.piece_box_piece_counts_adjust())
    },

    // 玉の自動配置
    sp_king_formation_auto_set_on_off(v) {
      return this.sp_call(e => e.mediator.king_formation_auto_set_on_off(v))
    },

    // スマホから戻ったときに音が鳴るようにする
    // sp_sound_resume_all() {
    //   return this.sp_call(e => e.sp_sound_resume_all())
    // },

    sp_Howler() {
      return this.sp_call(e => e.sp_Howler())
    },

  },
  computed: {
    play_mode_p() { return this.sp_run_mode === 'play_mode' },
    edit_mode_p() { return this.sp_run_mode === 'edit_mode' },
    advanced_p()  { return this.current_turn > this.config.record.initial_turn }, // 最初に表示した手数より進めたか？

    // current_sfen_attrs() {      // 指し手の情報なので turn は指した手の turn を入れる
    //   return {
    //     sfen: this.current_sfen,
    //     turn: this.current_sfen_info.turn_offset_max, // これを入れない方が早い？
    //     //- last_location_key: this.current_sfen_info.last_location.key,
    //   }
    // },
    current_sfen_info()            { return this.sfen_parse(this.current_sfen)                          },
    current_sfen_turn_offset_max() { return this.current_sfen_info.turn_offset_max                      },
    next_location()                { return this.current_sfen_info.next_location                        },
    current_location()             { return this.current_sfen_info.location_by_offset(this.current_turn) },
    base_location()                { return this.current_sfen_info.location_by_offset(0)                },

    current_xsfen()                { return { sfen: this.current_sfen, turn: this.current_turn } },

    sp_class() {
      const av = []
      if (this.current_turn_self_p) {
        av.push("current_turn_self_p")
      }
      return av
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 将棋盤の下のコントローラーを表示しない条件
    // 対局時計が設置されていて STOP または PAUSE 状態のとき
    controller_disabled_p() {
      if (this.ctrl_mode_info.key === "is_ctrl_mode_hidden") {
        if (this.clock_box) {
          return this.clock_box.working_p
        }
      }
    },
  },
}
