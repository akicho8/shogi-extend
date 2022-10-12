// チャット発言送信

import MessageSendModal from "./MessageSendModal.vue"
import { MessageScopeInfo } from "../models/message_scope_info.js"
import { InsideCommandInfo } from "../models/inside_command_info.js"
import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"
import { Xmessage } from "./xmessage.js"

export const app_message = {
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
      if (this.inside_command_run(params) === "break") {
        return
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
      const xmessage = Xmessage.create(params)
      this.ml_add_xmessage(xmessage)                  // 後で表示するためスコープに関係なく発言履歴に追加する
      if (this.message_share_received_p(params)) {    // 見てもいいなら
        this.$buefy.toast.open(xmessage.toast_params) // 表示
        this.talk(xmessage.message)                   // しゃべる
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

    inside_command_run(params) {
      if (params.message.startsWith("/")) {
        this.local_say(params.message)
        let str = params.message
        str = str.replace(/^./, "")
        str = str.trim()
        const args = this.str_split(str)
        const command = args.shift()
        const info = InsideCommandInfo.lookup(command)
        if (info == null) {
          this.local_bot_say("command not found")
        } else {
          let value = null
          try {
            value = info.command_fn(this, args)
          } catch (e) {
            console.error(e)
            value = e
          }
          if (value != null) {
            if (!_.isString(value)) {
              value = Gs2.short_inspect(value)
            }
            this.local_bot_say(value)
          }
        }
        return "break"
      }
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
