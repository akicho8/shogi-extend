import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export const mod_function_disable = {
  methods: {
    cc_play_then_warning() {
      if (this.cc_play_p) {
        this.sfx_click()
        this.disable_message_show()
        return true
      }
    },
    async disable_message_show() {
      await this.toast_primary("安全のため対局中の実行を制限しています")
      await this.toast_primary("実行するには時計を一時停止してください")
    },
  },
  computed: {
    // active_member_p() { return this.cc_play_p && this.i_am_member_p }, // 自分は対局中の対局者か？
  },
}
