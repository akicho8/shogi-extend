const CC_INPUT_DEBOUNCE_DELAY_SEC = 0.5 // 時計の同期のために操作が終わったと判断する秒数 (テスト側と値を合わせる)

import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export const clock_box_form = {
  created() {
    this.cc_input_handle_debounce_on()
  },
  beforeDestroy() {
    this.cc_input_handle_debounce_off()
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    // 時計の値を動かしているときに他の人に動かした値を伝える
    // しかし毎回伝えるとサーバーが死ぬので動かし終わってX秒後に伝える

    // X秒後に呼ぶ設定
    cc_input_handle_debounce_on() {
      this.cc_input_handle_debounce_trailing = _.debounce(() => { this.cc_input_handle_trailing_task() }, CC_INPUT_DEBOUNCE_DELAY_SEC * 1000, { leading: false, trailing: true  })
    },
    cc_input_handle_debounce_off() {
      this.debug_alert("cc_input_handle_debounce_off")
      this.cc_input_handle_debounce_trailing.cancel()
    },
    // 操作時に毎回呼ぶ
    cc_input_handle(v) {
      this.cc_params_apply_without_save()  // リアルタイムに反映する
      this.cc_input_handle_debounce_trailing()
    },
    // 操作後X秒後に呼ぶ
    cc_input_handle_trailing_task() {
      this.debug_alert("cc_input_handle_trailing_task")
      this.cc_params_save()                     // 何度も localStorage に保存すると遅いので操作後にする
      this.clock_box_share("cc_behavior_input") // みんなへの同期も操作後にする
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
