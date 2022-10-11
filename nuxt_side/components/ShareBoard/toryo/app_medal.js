import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export const app_medal = {
  data() {
    return {
      medal_counts_hash: {},
    }
  },
  methods: {
    // チーム毎に一括でメダル付与
    // win_location_key 側のチームのみんなを plus する
    medal_plus_handle(win_location_key, plus = 1) {
      const win_location = Location.fetch(win_location_key)
      const hv = _.clone(this.medal_counts_hash) // ここでは medal_counts_hash を破壊しない
      this.room_user_names.forEach(e => {
        const location = this.user_name_to_initial_location(e)
        if (location) {
          if (location.key === win_location.key) {
            hv[e] = (hv[e] ?? 0) + plus
          }
        }
      })
      this.medal_counts_hash_share(hv)
    },

    // 指定のユーザーだけにこっそりメダル付与 (デバッグ用)
    medal_plus_to_user_handle(user_name, plus = 1) {
      const hv = _.clone(this.medal_counts_hash) // ここでは medal_counts_hash を破壊しない
      hv[user_name] = (hv[this.user_name] ?? 0) + plus
      this.medal_counts_hash_share(hv)
    },

    // 共有
    medal_counts_hash_share(medal_counts_hash) {
      this.ac_room_perform("medal_counts_hash_share", {medal_counts_hash: medal_counts_hash})
    },
    medal_counts_hash_share_broadcasted(params) {
      this.receive_medal_counts_hash(params.medal_counts_hash)
    },
    receive_medal_counts_hash(medal_counts_hash) {
      Gs2.__assert__(medal_counts_hash, "medal_counts_hash")
      this.medal_counts_hash = medal_counts_hash // 自分もみんなと同じようにここだけで更新する
    },
  },
}
