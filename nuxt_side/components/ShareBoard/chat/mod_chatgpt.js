import { ChatgptRequestInfo } from "./chatgpt_request_info.js"
import { CcInfo             } from "../clock/cc_info.js"
import dayjs from "dayjs"
import { Gs } from "@/components/models/gs.js"

export const mod_chatgpt = {
  methods: {
    gpt_speak(params) {
      params = {
        message_scope_key: this.message_scope_info.key, // 発言者のスコープを元にする
        ...params,
      }
      params.message ??= ""                             // null チェックをかわすため
      this.ac_room_perform("gpt_speak", params)         // --> app/channels/share_board/room_channel.rb

      // 確認のため
      if (!this.$route.query.__system_test_now__ || true) {
        if (this.debug_mode_p) {
          this.local_bot_say(params.message)
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    gpt_speak_for(key, params) {
      const message = ChatgptRequestInfo.fetch(key).command_fn(this, params)
      if (message != null) {
        this.gpt_speak({message: message})
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    gpt_case_hello(params) {
      if (this.received_from_self(params)) {
        const ymd = dayjs().format("YYYY-MM-DD")
        if (this.gpt_hello_ymd !== ymd) {
          this.gpt_hello_ymd = ymd
          this.gpt_speak_for("参加者にあいさつする", params)
        } else {
          this.debug_alert("本日はもう挨拶しました")
        }
      }
    },

    gpt_case_odai(params) {
      if (this.received_from_self(params)) {
        this.gpt_speak_for("お題に答える", params)
      }
    },

    gpt_case_illegal(params) {
      if (this.received_from_self(params)) {
        if (this.$gs.present_p(params.illegal_names)) {
          if (this.cc_play_p) {
            // 自動投了だと「反則した人を励ます」と「見応えのある対局だったと褒める」が重なってしまうため自動投了しないときだけ発言させる
            if (this.auto_resign_info.key === "is_auto_resign_off") {
              this.gpt_speak_for("反則した人を励ます", params)
            }
          }
        }
      }
    },

    gpt_case_turn(params) {
      if (this.received_from_self(params)) {
        if (this.cc_play_p) {
          this.gpt_speak_for("局面にコメントする", params)
        }
      }
    },

    gpt_case_clock(params) {
      if (this.received_from_self(params)) {
        const cc_info = CcInfo.fetch(params.cc_key)
        if (cc_info.key === "ck_start") {
          this.gpt_speak_for("対局を盛り上げる", params)
        }
        if (cc_info.key === "ck_timeout") {
          // 自動投了だと「時間切れで負けた人を励ます」と「見応えのある対局だったと褒める」が重なってしまうため自動投了しないときだけ発言させる
          if (this.auto_resign_info.key === "is_auto_resign_off") {
            this.gpt_speak_for("時間切れで負けた人を励ます", params)
          }
        }
      }
    },

    gpt_case_give_up(params) {
      if (this.received_from_self(params)) {
        this.gpt_speak_for("見応えのある対局だったと褒める", params)
      }
    },
  },
}
