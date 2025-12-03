// |-----------------------+----------------------------------------|
// | methods               | description                            |
// |-----------------------+----------------------------------------|
// | give_up_submit_handle | 最後の「投了する」ボタンを押した       |
// | timeout_then_resign   | 時間切れかつ自動投了モードなら投了する |
// |-----------------------+----------------------------------------|

import { give_up_modal } from "./give_up_modal.js"
import { GX } from "@/components/models/gx.js"

export const mod_give_up = {
  mixins: [give_up_modal],

  methods: {
    // 最後の「投了する」ボタンを押した
    give_up_submit_handle() {
      this.sfx_click()
      this.give_up_modal_close()
      if (!this.give_up_modal_open_button_show_p) {
        this.toast_danger("投了確認モーダルを出している間に投了できる条件が無効になりました")
        return
      }
      this.give_up_direct_run_with_valid()
    },

    // 自分が生きていて時間切れしたとき自動投了モードなら投了する
    timeout_then_resign() {
      if (this.auto_resign_info.key === "is_auto_resign_on") {
        this.give_up_direct_run_with_valid()
      }
    },

    // 最終投了ボタンを押したときの処理
    give_up_direct_run_with_valid() {
      if (!this.give_up_modal_open_button_show_p) {
        this.toast_danger("投了確認している最中に投了できなくなりました")
        return
      }
      this.give_up_direct_run()
    },

    // そのまま実行
    // 投了メッセージをカスタマイズしたくなるが結局チャットでもみんな「負けました」としか言わないので固定で良い
    // 必要ないところをこだわって複雑にしてはいけない
    // 処理順序重要
    give_up_direct_run() {
      this.give_up_modal_close()   // 本人が時間切れは失礼と考えて投了モーダルを出して投了を押す瞬間に時間切れが先に発動した場合を想定してモーダルを強制的に閉じる
      this.give_up_messsage_post() // 発言は何も影響ないので最初に行う
      this.battle_save_run()       // 順番設定がある状態で対局を保存する
      this.give_up_share()         // 最後に順番設定を解除する
    },

    give_up_messsage_post() {
      this.message_share({content: "負けました", message_scope_key: "ms_public", force_talk: true})
    },

    // 投了トリガーを配る
    give_up_share() {
      const params = { win_location_key: this.give_up_win_location_key }
      this.ac_room_perform("give_up_share", params) // --> app/channels/share_board/room_channel.rb
    },
    give_up_share_broadcasted(params) {
      this.al_add({...params, label: "投了", label_type: "is-danger"}) // 履歴に追加する。別になくてもよい
      this.honpu_main_setup()                    // 本譜を作る。すでにあれば上書き
      this.give_up_modal_close()              // もし味方が投了しようとしていればモーダルを閉じる

      // 投了を押した本人が時計と順番を解除する
      // この処理は give_up_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      if (this.received_from_self(params)) {
        this.cc_stop_share_handle()   // 時計 STOP
        this.order_switch_off_share() // 順番 OFF
        this.quiz_delete()            // 配送したお題の削除
      }

      // 励ます
      this.ai_say_case_give_up(params)

      // ログインしていれば自分に棋譜を送信する
      // このときオプションとして勝ち負けの情報を入れておいて題名のアイコンを変化させる
      if (this.login_and_email_valid_p) {
        this.kifu_mail_run({silent: true, sb_judge_key: this.give_up_then_self_judge_key(params)})
      }

      this.honpu_announce()
    },

    async honpu_announce() {
      await GX.sleep(this.__SYSTEM_TEST_RUNNING__ ? 0 : 5)
      await this.toast_primary("💡 棋譜は上の本譜ボタンからコピーできるよ", {talk: false, duration_sec: 20})
    },

    // 投了時に自分のチームは勝ったのか？
    // 返すキーは sb_judge_info.rb に合わせること
    give_up_then_self_judge_key(params) {
      if (params.win_location_key) {                              // 勝ち負けが明確で
        if (this.my_location) {                                   // 自分は対局者で
          if (this.my_location.key === params.win_location_key) { // 勝った場合
            return "win"
          } else {
            return "lose"
          }
        } else {
          // params.win_location_key 側が勝ったことはわかるけど自分は観戦者だったので勝ち負けに関心はない
          return "none"
        }
      } else {
        // 観戦者が投了ボタンを押したため勝ち負け不明
        return "none"
      }
    },
  },

  computed: {
    // 投了ボタン表示条件
    // ・対局メンバーに含まれる ← やめ
    // ・対局メンバーに含まれる かつ 時計が PLAY 状態 ← こっちにした
    give_up_modal_open_button_show_p() {
      return this.i_am_member_p && this.cc_play_p
    },

    // 投了ボタンを押した瞬間の勝った側を返す
    give_up_win_location_key() {
      const params = {}
      if (this.AppConfig.TORYO_THEN_CURRENT_LOCATION_IS_LOSE) {
        // 方法1: 投了ボタンが押されたときの手番のチームを負けとする
        // 誰が投了したかに関係なく、投了時点の手番のチームが負けで、その相手が勝ちとする
        // これは二歩したとき手番が相手に移動しているため、そこで投了すると逆になってしまうので却下
        return this.current_location.flip.key
      } else {
        GX.assert(this.my_location, "観戦者が投了した (普通の遷移ではここに来ない)")
        // 方法2: 投了ボタンを押した人を負けとする
        // デメリットとしては代わりに押してあげることができない
        return this.my_location.flip.key // 自分が投了したので相手色の勝ち
      }
    },
  },
}
