import ToryoConfirmModal from "./ToryoConfirmModal.vue"

export const app_toryo = {
  methods: {
    // 投了確認モーダル発動
    toryo_confirm_handle() {
      this.$sound.play_click()
      this.modal_card_open({
        component: ToryoConfirmModal,
        props: { base: this.base },
      })
    },

    // 投了ボタンを押したときの処理
    toryo_run_from_modal() {
      if (!this.toryo_button_show_p) {
        this.toast_ng("投了確認を出している間に投了できなくなりました")
        return
      }
      this.toryo_direct_run()
    },

    // そのまま実行
    // 投了メッセージをカスタマイズしたくなるが結局チャットでもみんな「負けました」としか言わないので固定で良い
    // 必要ないところをこだわって複雑にしてはいけない
    toryo_direct_run() {
      this.message_share({message: "負けました", message_scope_key: "is_message_scope_public"})
      this.toryo_share()
    },

    // 投了トリガーを配る
    toryo_share() {
      const params = {}
      if (true) {
        // 方法1: 投了ボタンが押されたときの手番のチームを負けとする
        // 誰が投了したかに関係なく、投了時点の手番のチームが負けで、その相手が勝ちとする
        // これは二歩したとき手番が相手に移動しているため、そこで投了すると逆になってしまうので却下
        params.win_location_key = this.current_location.flip.key
      } else {
        // 方法2: 投了ボタンを押した人を負けとする
        if (this.my_location) {                               // 自分が対局者なら
          params.win_location_key = this.my_location.flip.key // 自分が投了したので相手色の勝ち
        } else {
          // 普通の遷移ではここに来ないが来た場合は観戦者が押したことになる
        }
      }
      this.ac_room_perform("toryo_share", params) // --> app/channels/share_board/room_channel.rb
    },
    toryo_share_broadcasted(params) {
      this.al_add({...params, label: "投了"}) // 履歴に追加する。別になくてもよい
      this.honpu_log_set()                    // 本譜を作る。すでにあれば上書き

      // 投了を押した本人が時計と順番を解除する
      // この処理は toryo_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      if (this.received_from_self(params)) {
        this.cc_stop_share_handle()   // 時計 STOP
        this.order_switch_off_share() // 順番 OFF
      }

      if (params.win_location_key) {                              // 勝ち負けが明確で
        if (this.my_location) {                                   // 自分は対局者で
          if (this.my_location.key === params.win_location_key) { // 勝った場合
          }
        }
      }

      // ログインしていれば自分に棋譜を送信する
      if (this.g_current_user) {
        this.kifu_mail_run({
          silent: true,
          sb_judge_key: this.toryo_then_self_judge_key(params),
        })
      }
    },

    // 投了時に自分のチームは勝ったのか？
    toryo_then_self_judge_key(params) {
      if (params.win_location_key) {                              // 勝ち負けが明確で
        if (this.my_location) {                                   // 自分は対局者で
          if (this.my_location.key === params.win_location_key) { // 勝った場合
            return "win"
          } else {
            return "lose"
          }
        } else {
          // params.win_location_key 側が勝ったことはわかる
          // だが、自分は観戦者
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
    // ・時計が PLAY 状態
    toryo_button_show_p() {
      return this.self_is_member_p && this.cc_play_p
    },
  },
}
