const ARASHI_THRESHOLD = 3      // 荒らし判定閾値
const ARASHI_RE_RATE   = 4      // 1/n の確率で反応する

// AIが発動する条件を書く

import { AiResponseInfo } from "./ai_response_info.js"
import { MessageRecord } from "./message_record.js"
import { CcBehaviorInfo } from "../clock/cc_behavior_info.js"
import dayjs from "dayjs"
import { Gs } from "@/components/models/gs.js"

export const mod_chat_ai_trigger_rule = {
  data() {
    return {
      arashi_count: 0,           // 荒らし判定回数
    }
  },
  methods: {
    // /gpt または /gpt xxx
    ai_something_say(params) {
      params = {
        message_scope_key: this.message_scope_info.key, // 発言者のスコープを元にする
        ...params,
      }
      params.content ??= ""                             // null チェックをかわすため
      this.ac_room_perform("ai_something_say", params)         // --> app/channels/share_board/room_channel.rb

      if (this.debug_mode_p) {
        this.ml_bot_puts(`ai_something_say: "${params.content}"`)
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // /gpt xxx の xxx を自動で作る
    ai_say_for(delay, key, params) {
      if (!this.GPT_FUNCTION) { return }
      let content = AiResponseInfo.fetch(key).command_fn(this, params)
      if (content != null) {
        content = [content, "返答は短かく簡潔にすること。"].join("")
        if (this.$route.query.__system_test_now__) {
          delay = 0
        }
        Gs.delay_block(delay, () => this.ai_something_say({content: content}))
      }
    },

    //////////////////////////////////////////////////////////////////////////////// 特殊

    // ときどき自動で /gpt を実行する
    // このとき直前に送った人のスコープを真似する
    ai_random_say(params) {
      if (!this.GPT_FUNCTION) { return }
      if (this.$route.query.__system_test_now__) { return }

      if (this.received_from_self(params)) { // ここで Bot は弾くので無限ループにはならない
        const value = Math.random()
        const call = value < this.ai_auto_response_ratio // 0.0:必ずfalse 1.0:必ず反応する
        this.clog([value, this.ai_auto_response_ratio, call])
        if (call) {
          this.ai_something_say({content: "", message_scope_key: params.message_scope_key})
        }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    ai_say_case_hello(params) {
      if (this.received_from_self(params)) {
        const ymd = dayjs().format("YYYY-MM-DD")
        if (this.ai_hello_ymd !== ymd) {
          this.ai_hello_ymd = ymd // 本日はあいさつしたとする (しかしLINEから来られるとクッキーが効かず保存できない罠がある)
          if (this.cc_play_p) {    // BUG: 時計の情報が届く前に見ているため常に false になる
            // 対局中は参加者にあいさつをスキップする
          } else {
            this.ai_say_for(0, "参加者にあいさつする", params)
          }
        } else {
          this.debug_alert("本日はもう挨拶しました")
        }
      }
    },

    ai_say_case_odai(params) {
      if (this.received_from_self(params)) {
        this.ai_say_for(2, "お題に答える", params)
      }
    },

    ai_say_case_illegal(params) {
      if (this.received_from_self(params)) {
        if (Gs.present_p(params.illegal_names)) {
          if (this.cc_play_p) {
            // 自動投了だと「反則した人を励ます」と「見応えのある対局だったと褒める」が重なってしまうため自動投了しないときだけ発言させる
            if (this.auto_resign_info.key === "is_auto_resign_off") {
              if (this.ai_say_turn_gteq(1)) {
                this.ai_say_for(3, "反則した人を励ます", params)
              }
            }
          }
        }
      }
    },

    ai_say_case_turn(params) {
      if (this.received_from_self(params)) {
        if (this.cc_play_p) {
          this.ai_say_for(0, "局面にコメントする", params)
        }
      }
    },

    ai_say_case_clock(params) {
      if (this.received_from_self(params)) {
        const cc_behavior_info = CcBehaviorInfo.fetch(params.cc_behavior_key)
        if (cc_behavior_info.key === "cc_behavior_start") {
          this.ai_say_for(3, "対局を盛り上げる", params)
        }
        if (cc_behavior_info.key === "cc_behavior_timeout") {
          // 自動投了だと「時間切れで負けた人を励ます」と「見応えのある対局だったと褒める」が重なってしまうため自動投了しないときだけ発言させる
          if (this.auto_resign_info.key === "is_auto_resign_off") {
            if (this.ai_say_turn_gteq(1)) {
              this.ai_say_for(3, "時間切れで負けた人を励ます", params)
            }
          }
        }
      }
    },

    ai_say_case_give_up(params) {
      if (this.received_from_self(params)) {
        if (this.ai_say_turn_gteq(50)) {
          this.ai_say_for(3, "見応えのある対局だったと褒める", params)
        }
      }
    },

    ai_say_case_arashi(message_record) {
      if (this.received_from_self(message_record)) {
        if (message_record.content_invalid_p) {
          this.arashi_count += 1
          if (this.arashi_count >= this.ARASHI_THRESHOLD) {
            if (Gs.irand(this.ARASHI_RE_RATE) === 0) {
              this.ai_say_for(0, "チャット荒らしに怒る", message_record)
            }
          }
        }
      }
    },

    // private

    ai_say_turn_gteq(turn) {
      if (this.$route.query.__system_test_now__) { return true }
      return this.current_turn >= turn
    }
  },

  computed: {
    ARASHI_THRESHOLD() { return parseInt(this.$route.query.ARASHI_THRESHOLD ?? ARASHI_THRESHOLD) },
    ARASHI_RE_RATE()   { return parseInt(this.$route.query.ARASHI_RE_RATE ?? ARASHI_RE_RATE) },

    GPT_FUNCTION() { return this.ai_mode_info.key === "ai_mode_on" && this.AppConfig.GPT_FUNCTION },
  },
}
