// |----------------------+----------------------------------|
// | methods              | description                      |
// |----------------------+----------------------------------|
// | normal_resign_call_handle | 最後の「投了する」ボタンを押した |
// | resign_action          | 投了する                         |
// |----------------------+----------------------------------|

import { resign_confirm_modal } from "./resign_confirm_modal.js"
import { ending_modal } from "./ending_modal.js"
import { GX } from "@/components/models/gx.js"
import { EndingContext } from "./ending_context.js"
import { EndingRouteInfo } from "./ending_route_info.js"
import { EndingRouteTestInfo } from "./ending_route_test_info.js"
import { RoleGroup } from "../mod_role/role_group.js"
import { IllegalInfo } from "shogi-player/components/models/illegal_info.js"

export const mod_resign = {
  mixins: [
    resign_confirm_modal,
    ending_modal,
  ],

  data() {
    return {
      ending_context: null,
    }
  },

  methods: {
    // 最後の「投了する」ボタンを押した
    normal_resign_call_handle() {
      this.resign_action({ending_route_key: "er_user_normal_resign", resigned_user_name: this.user_name})
    },

    // 投了トリガーを配る
    // 最終投了ボタンを押したときの処理
    // 自分が生きていて時間切れしたとき自動投了モードなら投了する
    // 投了メッセージをカスタマイズしたくなるが結局チャットでもみんな「負けました」としか言わないので固定で良い
    // 必要ないところをこだわって複雑にしてはいけない
    resign_action(params = {}) {
      if (!this.resign_can_p) {
        this.toast_danger("投了確認している最中に投了できなくなりました")
        return
      }

      // あとで以下を EndingContext に渡す
      params = {
        __nullable_attributes__: ["win_location_key"],
        ending_route_key: "er_user_normal_resign",              // 投了にいたった理由
        win_location_key: this.resign_win_location_key,         // 勝った側 (空の場合は引き分け)
        role_group_attributes: this.room_role_group.attributes, // この時点のメンバー情報を持っておく (あとでやると対局設定がOFFになっているか気にかけないといけない)
        ...params,
      }

      this.resign_confirm_modal_close()                          // 本人が時間切れは失礼と考えて投了モーダルを出して投了を押す瞬間に時間切れが先に発動した場合を想定してモーダルを強制的に閉じる
      this.illegal_takeback_modal_close()                        // 反則からの投了確認モーダルが出ている場合があるので消す
      this.battle_save_by_win_location(params.win_location_key) // 対局設定がある状態で対局を保存する

      this.ac_room_perform("resign_action", params) // --> app/channels/share_board/room_channel.rb
    },
    resign_action_broadcasted(params) {
      this.ending_call({my_location_key: this.my_location_key, ...params})

      this.xhistory_add({...params, label: this.ending_context.ending_route_info.name, label_type: "is-danger"}) // 履歴に追加する。別になくてもよい

      this.honpu_master_setup()         // 本譜を作る。すでにあれば上書き
      this.resign_confirm_modal_close() // もし味方が投了しようとしていればモーダルを閉じる

      // ログインしていれば自分に棋譜を送信する
      // このときオプションとして勝ち負けの情報を入れておいて題名のアイコンを変化させる
      // 対局設定OFFよりも前で行うこと
      this.kifu_mail_run_safe()

      // 投了を押した本人が時計と順番を解除する
      // この処理は resign_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      // 対局設定は最後にOFFにすること
      if (this.received_from_self(params)) {
        this.quiz_delete()            // 配送したお題の削除
        this.cc_stop_share_handle()   // 時計 STOP
        this.order_switch_off_share() // 順番 OFF
      }
    },

    // 引分
    draw_call() {
      this.battle_save_by_win_location(null)                // 対局設定がある状態で対局を保存する
      this.resign_action({ending_route_key: "er_auto_draw"}) // 最後に対局設定を解除する
    },

    ending_call(params) {
      this.ending_context = EndingContext.create(params)
      if (this.ending_context.ending_route_info.sfx_key) {
        this.sfx_stop_all()
        this.sfx_play(this.ending_context.ending_route_info.sfx_key)
      }
      if (this.ending_context.toast_content) {
        this.toast_primary(this.ending_context.toast_content)
      }
      if (this.ending_context.talk_content) {
        this.talk(this.ending_context.talk_content)
      }
      if (this.ending_context.ending_route_info.modal_show) {
        this.ending_modal_open()
      }
    },

    ending_call_test(params = {}) {
      params = {
        win_location_key: "black",
        ending_route_key: "er_user_normal_resign",
        role_group_attributes: {
          black: ["b1", "b2"],
          white: ["w1", "w2"],
        },
        my_location_key: this.Location.black,
        illegal_hv_list: [
          { illegal_info: IllegalInfo.fetch("illegal_double_pawn") },
        ],
        ...params,
      }
      this.ending_call(params)
    },
  },

  computed: {
    EndingRouteInfo() { return EndingRouteInfo },
    EndingRouteTestInfo() { return EndingRouteTestInfo },

    // 投了ボタン表示条件
    // 反則ブロックモーダルを出しているとき時計は PAUSE なので PAUSE を含めること
    resign_can_p() {
      return this.i_am_member_p && this.cc_pause_or_play_p
    },

    // 投了ボタンを押した瞬間の勝った側を返す
    // 投了ボタンを押した人を負けとする
    resign_win_location_key() {
      if (this.my_location) {
        return this.my_location.flip.key // 自分が投了したので相手色の勝ち
      }
    },
  },
}
