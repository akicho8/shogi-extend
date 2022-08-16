import ToryoConfirmModal from "./ToryoConfirmModal.vue"

export const app_toryo = {
  methods: {
    // 投了確認モーダル発動
    toryo_confirm_handle() {
      this.sound_play_click()
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
    toryo_share(params = {}) {
      this.ac_room_perform("toryo_share", params) // --> app/channels/share_board/room_channel.rb
    },
    toryo_share_broadcasted(params) {
      this.al_add({...params, label: "投了"}) // 履歴に追加する。別になくてもよい
      this.honpu_log_set()                    // 本譜を作る。すでにあれば上書き

      // 投了を押した本人が時計と順番を解除する
      // この処理は toryo_direct_run で行う手もあるが「投了」→「時計停止」→「順番OFF」の順で
      // 履歴に入れたいのでこっちの方がよい
      if (this.received_from_self(params)) {
        this.cc_stop_share_handle()   // 時計 停止
        this.order_switch_off_share() // 順番 OFF
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
