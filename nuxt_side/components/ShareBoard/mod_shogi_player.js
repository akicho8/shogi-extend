const DEBOUNCE_DELAY = 1000 * 1.0   // 1秒後に反映

import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_shogi_player = {
  data() {
    return {
      short_sfen: "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
    }
  },

  methods: {
    // 操作モードで指したときの処理
    // 局面0で1手指したとき last_move_info.next_turn_offset は 1
    ev_play_mode_move(e) {
      this.se_piece_move()

      // sfen と turn を同時に更新すること
      // そうしないと computed が二度走ってしまう
      this.current_sfen = e.sfen
      this.current_turn = e.turn  // last_move_info.next_turn_offset と同じ

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
        this.viewpoint = location.key
      }
    },

    // デバッグ用
    ev_short_sfen_change(sfen) {
      this.short_sfen = sfen
      // if (this.development_p) {
      //   this.$buefy.toast.open("short_sfen")
      // }
    },

    // 編集モード時の局面
    // ・常に更新するが、URLにはすぐには反映しない→やっぱり反映する
    // ・あとで current_sfen に設定する
    // ・すぐに反映しないのは駒箱が消えてしまうから
    ev_edit_mode_short_sfen_change(v) {
      GX.assert(this.sp_mode === "edit", 'this.sp_mode === "edit"')

      // NOTE: current_sfen に設定すると(current_sfenは駒箱を持っていないため)駒箱が消える
      // edit_modeの完了後に edit_mode_sfen を current_sfen に戻す
      this.edit_mode_sfen = v

      // 意図せず共有してしまうのを防ぐため共有しない
      // if (false) {
      //   this.sfen_share_params_set()
      // }
      // }
    },

    // ユーザーがコントローラやスライダーで手数を変更した瞬間
    ev_action_turn_change(v) {
      this.perpetual_cop.reset()
      this.ev_action_turn_change_se()
      this.ev_action_turn_change_lazy(v)
    },

    // ユーザーがコントローラやスライダーで操作し終わったら転送する
    ev_action_turn_change_lazy: _.debounce(function(v) {
      if (this.ac_room) {
        // https://twitter.com/Sushikuine_24/status/1522370383131062272
        this.$nextTick(() => this.quick_sync(`${this.my_call_name}が${v}手目に変更しました`, {notify_mode: "fs_notify_without_self"}))
      }
    }, DEBOUNCE_DELAY),

    // private

    // url_replace() {
    //   this.$router.replace({query: this.current_url_params})
    // },

    //////////////////////////////////////////////////////////////////////////////// 警告

    ////////////////////////////////////////////////////////////////////////////////

    // ShogiPlayer コンポーネント自体を実行したいとき用
    sp_call(func) {
      return func(this.$refs.SbSp.$refs.main_sp.sp_object())
    },

    // 持駒を元に戻す(デバッグ用)
    sp_lifted_piece_cancel() {
      return this.sp_call(e => e.api_lifted_piece_cancel())
    },

    // 駒箱調整
    sp_piece_box_piece_counts_adjust() {
      return this.sp_call(e => e.xcontainer.piece_box_piece_counts_adjust())
    },

    // 玉の自動配置
    sp_king_formation_auto_set_on_off(v) {
      return this.sp_call(e => e.xcontainer.king_formation_auto_set_on_off(v))
    },

    // 手数 → 色変換
    // 駒落ちによる開始色が変わる条件の大元はこれ
    turn_to_location(turn) {
      GX.assert_kind_of_integer(turn)
      return this.current_sfen_info.location_by_offset(turn)
    },
  },
  computed: {
    play_mode_p() { return this.sp_mode === "play" },
    edit_mode_p() { return this.sp_mode === "edit" },
    advanced_p()  { return this.current_turn > this.config.record.initial_turn }, // 最初に表示した手数より進めたか？

    // current_sfen_attrs() {      // 指し手の情報なので turn は指した手の turn を入れる
    //   return {
    //     sfen: this.current_sfen,
    //     turn: this.current_sfen_info.turn_offset_max, // これを入れない方が早い？
    //     //- last_location_key: this.current_sfen_info.last_location.key,
    //   }
    // },
    current_sfen_info()     { return this.sfen_parse(this.current_sfen)       }, // SFENのあらゆる情報
    current_sfen_turn_max() { return this.current_sfen_info.turn_offset_max   }, // 最後の手数
    next_location()         { return this.current_sfen_info.next_location     }, // 次の色
    current_location()      { return this.turn_to_location(this.current_turn) }, // 現在の色
    base_location()         { return this.turn_to_location(0)                 }, // 0手目の色
    start_color()           { return this.base_location.code                  }, // 0:平手 1:駒落ち (超重要)

    sfen_share_dto()         { return { sfen: this.current_sfen, turn: this.current_turn } },

    sp_class() {
      const av = []
      // if (this.current_turn_self_p) {
      //   av.push("current_turn_self_p")
      // } else {
      //   av.push("current_turn_not_self_p")
      // }
      return av
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 盤の下のコントローラーを表示しない条件
    controller_hide_p() { return this.cc_play_p          },
    controller_show_p() { return !this.controller_hide_p },

    // ここめっちゃ重要
    // デフォルトでは盤面を動かせないようにして条件に一致しているときだけ動かせるようにする
    sp_human_side() {
      // 思考印モードOFF 入室していない (これで対局時計だけを動かしてオフライン対局できるようになる)
      if (!this.think_mark_mode_p && this.ac_room == null) {
        return "both"
      }
      // 思考印モードOFF 順番設定OFF 対局時計動いていない
      if (!this.think_mark_mode_p && this.order_clock_both_empty) {
        return "both"
      }
      // 思考印モードOFF 順番設定ON 対局時計動いている 自分の手番
      if (!this.think_mark_mode_p && this.order_clock_both_ok && this.current_turn_self_p) {
        return "both"
      }
      // それ以外全部禁止
      return "none"
    },
  },
}
