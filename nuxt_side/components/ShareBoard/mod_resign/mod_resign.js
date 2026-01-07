// |----------------------+----------------------------------|
// | methods              | description                      |
// |----------------------+----------------------------------|
// | resign_call_handle | 最後の「投了する」ボタンを押した |
// | resign_call          | 投了する                         |
// |----------------------+----------------------------------|

import { resign_confirm_modal } from "./resign_confirm_modal.js"
import { ending_modal } from "./ending_modal.js"
import { GX } from "@/components/models/gx.js"

export const mod_resign = {
  mixins: [
    resign_confirm_modal,
    ending_modal,
  ],

  methods: {
    // 最後の「投了する」ボタンを押した
    resign_call_handle() {
      this.sfx_click()
      this.resign_confirm_modal_close()
      this.resign_call()
    },

    // 最終投了ボタンを押したときの処理
    // 自分が生きていて時間切れしたとき自動投了モードなら投了する
    // 投了メッセージをカスタマイズしたくなるが結局チャットでもみんな「負けました」としか言わないので固定で良い
    // 必要ないところをこだわって複雑にしてはいけない
    // 処理順序重要
    resign_call(options = {}) {
      options = {
        win_location_key: this.resign_win_location_key, // 勝った側 (空の場合は引き分け)
        checkmate: false,                               // 詰みの状態だったか？
        modal_show: true,                               // 結果のモーダルを表示するか？
        ...options,
      }
      if (!this.resign_can_p) {
        this.toast_danger("投了確認している最中に投了できなくなりました")
        return
      }
      this.resign_confirm_modal_close()                          // 本人が時間切れは失礼と考えて投了モーダルを出して投了を押す瞬間に時間切れが先に発動した場合を想定してモーダルを強制的に閉じる
      this.illegal_takeback_modal_close()                        // 反則からの投了確認モーダルが出ている場合があるので消す

      if (options.win_location_key && !options.checkmate) {      // 詰ましたときに「負けました」と言われると詰ました方が負けたように感じるので詰みの場合は「負けました」は言わないようにする
        this.resign_messsage_post()                              // 発言は何も影響ないので最初に行う
      }

      this.battle_save_by_win_location(options.win_location_key) // 順番設定がある状態で対局を保存する
      this.resign_share(options)                                 // 最後に順番設定を解除する
    },

    resign_messsage_post() {
      this.message_share({content: "負けました", message_scope_key: "ms_public", force_talk: true})
    },

    // 投了トリガーを配る
    resign_share(params = {}) {
      params = {
        __nil_check_skip_keys__: "win_location_key",
        ...params,
      }
      this.ac_room_perform("resign_share", params) // --> app/channels/share_board/room_channel.rb
    },
    resign_share_broadcasted(params) {
      {
        const label = params.win_location_key ? "投了" : "引き分け"
        this.al_add({...params, label: label, label_type: "is-danger"}) // 履歴に追加する。別になくてもよい
      }

      if (params.win_location_key == null) {
        this.toast_primary("引き分けです")
      }

      this.honpu_main_setup()                    // 本譜を作る。すでにあれば上書き
      this.resign_confirm_modal_close()          // もし味方が投了しようとしていればモーダルを閉じる

      // 投了を押した本人が時計と順番を解除する
      // この処理は resign_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      if (this.received_from_self(params)) {
        this.cc_stop_share_handle()   // 時計 STOP
        this.order_switch_off_share() // 順番 OFF
        this.quiz_delete()            // 配送したお題の削除
      }

      // 励ます
      if (params.win_location_key) {
        this.ai_say_case_resign(params)
      }

      // ログインしていれば自分に棋譜を送信する
      // このときオプションとして勝ち負けの情報を入れておいて題名のアイコンを変化させる
      if (this.login_and_email_valid_p) {
        this.kifu_mail_run({silent: true})
      }

      this.honpu_announce()

      if (params.modal_show) {
        this.ending_modal_open(params)
      }
    },

    async honpu_announce() {
      await GX.sleep(this.__SYSTEM_TEST_RUNNING__ ? 0 : 0)
      await this.toast_primary("棋譜は上の本譜ボタンからコピーできます", {talk: false, duration_sec: 8})
    },

    // 引分
    draw_call() {
      this.battle_save_by_win_location(null) // 順番設定がある状態で対局を保存する
      this.resign_share()                  // 最後に順番設定を解除する
    },
  },

  computed: {
    // 投了ボタン表示条件
    // 反則ブロックモーダルを出しているとき時計は PAUSE なので PAUSE を含めること
    resign_can_p() {
      return this.i_am_member_p && this.cc_pause_or_play_p
    },

    // 投了ボタンを押した瞬間の勝った側を返す
    resign_win_location_key() {
      if (this.AppConfig.TORYO_THEN_CURRENT_LOCATION_IS_LOSE) {
        // 方法1: 投了ボタンが押されたときの手番のチームを負けとする
        // 誰が投了したかに関係なく、投了時点の手番のチームが負けで、その相手が勝ちとする
        // これは二歩したとき手番が相手に移動しているため、そこで投了すると逆になってしまうので却下
        return this.current_location.flip.key
      }

      if (this.my_location) {
        // 方法2: 投了ボタンを押した人を負けとする
        // デメリットとしては代わりに押してあげることができない
        return this.my_location.flip.key // 自分が投了したので相手色の勝ち
      }
    },
  },
}
