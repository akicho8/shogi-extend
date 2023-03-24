import { ChatgptRequestInfo } from "./chatgpt_request_info.js"
import { CcInfo             } from "../clock/cc_info.js"

export const mod_chatgpt = {
  methods: {
    gpt_speak(params) {
      params = {
        message_scope_key: this.message_scope_info.key, // 発言者のスコープを元にする
        ...params,
      }
      params.message ??= ""                             // null チェックをかわすため
      this.ac_room_perform("gpt_speak", params)         // --> app/channels/share_board/room_channel.rb
    },

    ////////////////////////////////////////////////////////////////////////////////

    gpt_case_odai(params) {
      if (this.received_from_self(params)) {
        ChatgptRequestInfo.fetch("お題に答える").command_fn(this, params)
      }
    },

    gpt_case_illegal(params) {
      if (this.received_from_self(params)) {
        if (this.present_p(params.lmi.illegal_names)) {
          if (this.cc_play_p) {
            ChatgptRequestInfo.fetch("反則した人を励ます").command_fn(this, params)
          }
        }
      }
    },

    gpt_case_turn(params) {
      if (this.received_from_self(params)) {
        if (this.cc_play_p) {
          ChatgptRequestInfo.fetch("局面にコメントする").command_fn(this, params)
        }
      }
    },

    gpt_case_clock(params) {
      if (this.received_from_self(params)) {
        const cc_info = CcInfo.fetch(params.cc_key)
        if (cc_info.key === "ck_start") {
          ChatgptRequestInfo.fetch("対局を盛り上げる").command_fn(this, params)
        }
        if (cc_info.key === "ck_timeout") {
          ChatgptRequestInfo.fetch("時間切れで負けた人を励ます").command_fn(this, params)
        }
      }
    },

    gpt_case_give_up(params) {
      if (this.received_from_self(params)) {
        ChatgptRequestInfo.fetch("見応えのある対局だったと褒める").command_fn(this, params)
      }
    },
  },
}
