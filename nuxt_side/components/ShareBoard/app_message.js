import _ from "lodash"
import dayjs from "dayjs"
import MessageSendModal from "./MessageSendModal.vue"
import { MessageScopeInfo } from "./models/message_scope_info.js"

export const app_message = {
  data() {
    return {
      message_body: "",
    }
  },

  methods: {
    message_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: MessageSendModal,
        props: { base: this.base },
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    message_share(params) {
      this.ac_room_perform("message_share", params) // --> app/channels/share_board/room_channel.rb
    },

    message_share_broadcasted(params) {
      this.ml_add(params) // あとで表示するため対象でなくても受信はしておく

      if (this.message_share_received_p(params)) {
        this.$buefy.toast.open({
          container: ".MainBoard",
          message: `${params.from_user_name}: ${params.message}`,
          position: "is-top",
          type: params.message_scope_key === "is_ms_out" ? "is-success" : "is-white",
          queue: false,
        })
        this.talk(params.message)
      }
    },

    // 受信したメッセージを表示してもよいか？
    message_share_received_p(e) {
      let exec = true
      if (e.message_scope_key === "is_ms_out") {      // 観戦者宛のとき
        if (!this.received_from_self(e)) {          // 自分が送信者ではなく
          if (this.self_is_member_p) {              // 自分が対局者の場合は
            exec = false                            // 受信しない
          }
        }
      }
      return exec
    },
  },

  computed: {
    MessageScopeInfo()   { return MessageScopeInfo                                    },
    message_scope_info() { return this.MessageScopeInfo.fetch(this.message_scope_key) },

    // 観戦者宛送信ボタンを表示する？
    ms_audience_send_button_show_p() {
      if (false) {
        // 必要最低限表示したいときはこちらだけど利用者はボタンが出る条件が予想つかないかもしれない
        return this.watching_member_count >= 1 // 観戦者が1人以上いる場合
      }
      if (true) {
        return this.order_func_p // 単に順番設定している場合
      }
    },
  },
}
