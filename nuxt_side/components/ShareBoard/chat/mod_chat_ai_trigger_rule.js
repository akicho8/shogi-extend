const AI_RESPONSE_MODE = false  // 状況に応じて発言するか？

// AIが発動する条件を書く

import { GX } from "@/components/models/gx.js"

export const mod_chat_ai_trigger_rule = {
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

    //////////////////////////////////////////////////////////////////////////////// 特殊

    // ときどき自動で /gpt を実行する
    // このとき直前に送った人のスコープを真似する
    ai_random_say(params) {
      if (!this.ai_active) { return }
      if (this.__SYSTEM_TEST_RUNNING__) { return }

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
  },

  computed: {
    ai_active() { return this.ai_mode_info.key === "ai_mode_on" && this.AppConfig.ai_active },
  },
}
