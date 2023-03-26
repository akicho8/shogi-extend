// チャット発言送信

import MessageSendModal from "./MessageSendModal.vue"
import { MessageScopeInfo } from "../models/message_scope_info.js"
import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"
import { MessageDto } from "./message_dto.js"

export const mod_message = {
  data() {
    return {
      message_body: "",
    }
  },

  methods: {
    message_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: MessageSendModal,
      })
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 送信
    message_share(params) {
      if (this.console_command_run(params) === "break") {
        return
      }
      params = {
        message_scope_key: this.message_scope_info.key,
        ...params,
      }
      if (this.ac_room) {
        this.ac_room_perform("message_share", params) // --> app/channels/share_board/room_channel.rb
      } else {
        this.message_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...params,
        })
      }
    },

    // 受信
    message_share_broadcasted(params) {
      // console.log(params)

      const message_dto = MessageDto.create(params)
      this.ml_add_xmessage(message_dto)                  // 後で表示するためスコープに関係なく発言履歴に追加する
      if (this.message_share_received_p(params)) {    // 見てもいいなら
        this.$buefy.toast.open(message_dto.toast_params) // 表示
        this.talk2(message_dto.message)                 // しゃべる
      }
    },

    // 受信した発言を表示してもよいですか？
    message_share_received_p(e) {
      let exec = true
      if (e.message_scope_key === "is_message_scope_private") { // 観戦者宛のとき
        if (!this.received_from_self(e)) { // 自分が送信者ではなく
          if (this.self_is_member_p) {     // 自分が対局者の場合は
            exec = false                   // 受信しない
          }
        }
      }
      return exec
    },

    // ログ用の追加データとして data に名前を入れておく
    // 直接 talk を使うべからず
    talk2(message, options) {
      return this.talk(message, {data: this.user_name, ...options})
    },
  },

  computed: {
    MessageScopeInfo()   { return MessageScopeInfo                                    },
    message_scope_info() { return this.MessageScopeInfo.fetch(this.message_scope_key) },

    // 観戦者宛送信ボタンを表示する？
    message_scope_dropdown_show_p() {
      if (false) {
        // 必要最低限表示したいときはこちらだけど利用者はボタンが出る条件が予想つかないかもしれない
        return this.watching_member_count >= 1 // 観戦者が1人以上いる場合
      }
      if (true) {
        return this.order_enable_p // 単に順番設定している場合
      }
    },
  },
}
