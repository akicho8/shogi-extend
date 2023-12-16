// チャット発言送信

import ChatModal from "./ChatModal.vue"
import { MessageScopeInfo } from "../models/message_scope_info.js"
import { SendTriggerInfo } from "../models/send_trigger_info.js"
import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
import { MessageRecord } from "./message_record.js"

export const mod_chat = {
  data() {
    return {
      message_body: "",
      chat_modal_instance: null,
    }
  },

  beforeDestroy() {
    this.chat_modal_close()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    chat_modal_shortcut_handle() {
      if (this.chat_modal_instance == null) {
        this.sidebar_p = false
        this.$sound.play_click()
        this.chat_modal_open()
        return true
        // } else {
        //   this.chat_modal_close()
      }
    },

    chat_modal_open_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.chat_modal_open()
    },

    chat_modal_close_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.chat_modal_close()
    },

    chat_modal_open() {
      this.chat_modal_close()
      this.chat_modal_instance = this.modal_card_open({
        component: ChatModal,
        onCancel: () => {
          this.$sound.play_click()
          this.chat_modal_close()
        },
      })
    },

    chat_modal_close() {
      if (this.chat_modal_instance) {
        this.chat_modal_instance.close()
        this.chat_modal_instance = null
      }
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
      const message_record = MessageRecord.create(params)
      this.ml_add_xmessage(message_record)                  // 後で表示するためスコープに関係なく発言履歴に追加する
      if (this.ml_show_p(message_record)) {                 // 見てもいいなら
        this.$sound.play("patxu")                        // 「パッ」
        this.$buefy.toast.open(message_record.toast_params) // 表示
        this.talk2(message_record.content)                  // しゃべる
      }
    },

    // ログ用の追加データとして data に名前を入れておく
    // 直接 talk を使うべからず
    talk2(content, options = {}) {
      return this.talk(content, {
        data: this.user_name,
        // volume: this.talk_volume,
        ...options,
      })
    },

    send_trigger_p(e) {
      if (this.send_trigger_info.key === "send_trigger_enter") {
        return this.keyboard_enter_p(e)
      }
      if (this.send_trigger_info.key === "send_trigger_meta_enter") {
        return this.keyboard_enter_p(e) && this.keyboard_meta_p(e)
      }
    },
  },

  computed: {
    MessageScopeInfo()   { return MessageScopeInfo                                    },
    message_scope_info() { return this.MessageScopeInfo.fetch(this.message_scope_key) },

    SendTriggerInfo()   { return SendTriggerInfo                                    },
    send_trigger_info() { return this.SendTriggerInfo.fetch(this.send_trigger_key) },

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
