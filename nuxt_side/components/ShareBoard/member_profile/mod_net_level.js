import { NetLevelInfo } from "./net_level_info.js"

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"

const MS_PER_SECOND = 1000
const SEC_PER_MIN   = 60

export const mod_net_level = {
  methods: {
    // 指定メンバーの入室してからの経過秒数
    member_elapsed_sec_from_join(e) {
      return (this.$time.current_ms() - e.room_joined_at) / MS_PER_SECOND
    },

    // 指定メンバーの入室してから1分当たりの接続切れ数
    member_disconnected_count_per_min(e) {
      const count = e.ac_events_hash.disconnected || 0
      const min = this.member_elapsed_sec_from_join(e) / SEC_PER_MIN
      if (min === 0) {
        return count
      }
      return count / min
    },

    // 指定メンバーの通信環境
    member_net_level(e) {
      const v = this.member_disconnected_count_per_min(e)
      const found = NetLevelInfo.values.find(e => v >= e.threshold)
      GX.assert(found, "found")
      return found.name
    },
  },
}
