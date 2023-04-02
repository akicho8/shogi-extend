import GiveUpConfirmModal from "./GiveUpConfirmModal.vue"
import { Gs } from "@/components/models/gs.js"

export const mod_give_up = {
  methods: {
    // 投了確認モーダル発動
    give_up_confirm_handle() {
      this.$sound.play_click()
      this.modal_card_open({
        component: GiveUpConfirmModal,
      })
    },

    // 投了ボタンを押したときの処理
    give_up_run_from_modal() {
      if (!this.give_up_button_show_p) {
        this.toast_ng("投了確認を出している間に投了できなくなりました")
        return
      }
      this.give_up_direct_run()
      this.battle_save_run()
    },

    // そのまま実行
    // 投了メッセージをカスタマイズしたくなるが結局チャットでもみんな「負けました」としか言わないので固定で良い
    // 必要ないところをこだわって複雑にしてはいけない
    give_up_direct_run() {
      this.message_share({message: "負けました", message_scope_key: "is_message_scope_public"})
      this.give_up_share()
    },

    // 投了トリガーを配る
    give_up_share() {
      const params = { win_location_key: this.give_up_win_location_key }
      this.ac_room_perform("give_up_share", params) // --> app/channels/share_board/room_channel.rb
    },
    give_up_share_broadcasted(params) {
      this.al_add({...params, label: "投了", label_type: "is-danger"}) // 履歴に追加する。別になくてもよい
      this.honpu_log_set()                    // 本譜を作る。すでにあれば上書き

      // 投了を押した本人が時計と順番を解除する
      // この処理は give_up_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      if (this.received_from_self(params)) {
        this.cc_stop_share_handle()   // 時計 STOP
        this.order_switch_off_share() // 順番 OFF
        this.odai_delete()            // 配送したお題の削除
      }

      // 各自がポイント+1するのではなく投了ボタンを押した本人が勝った人全員のポイントを+1してbcする、としていたが
      // 問題が出てきたため各自がポイント+1することにした (これは medal_add_to_self_if_win のなかでの話だけどみんな呼ばないといけない)
      // if (this.received_from_self(params)) {
      if (params.win_location_key) {
        this.medal_add_to_self_if_win(params.win_location_key, 1)
      }
      // }

      // 励ます
      this.gpt_case_give_up(params)

      // ログインしていれば自分に棋譜を送信する
      // このときオプションとして勝ち負けの情報を入れておいて題名のアイコンを変化させる
      if (this.g_current_user) {
        this.kifu_mail_run({silent: true, sb_judge_key: this.give_up_then_self_judge_key(params)})
      }
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
    // ・対局メンバーに含まれる
    // ・時計が PLAY 状態 ← やめ
    give_up_button_show_p() {
      // return this.self_is_member_p && this.cc_play_p
      return this.self_is_member_p
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
        Gs.__assert__(this.my_location, "観戦者が投了した (普通の遷移ではここに来ない)")
        // 方法2: 投了ボタンを押した人を負けとする
        // デメリットとしては代わりに押してあげることができない
        return this.my_location.flip.key // 自分が投了したので相手色の勝ち
      }
    },
  },
}
