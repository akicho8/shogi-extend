// チャット内コマンドでのメダル操作(なくてもよい)

import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export const app_medal_plus = {
  methods: {
    // /medal-team コマンド用
    // チーム毎に一括でメダル付与したいときに使う
    // location_key 側のチームの人たちに加算するように伝える
    // あくまで加算は本人に行ってもらう
    medal_add_to_team(location_key, plus) {
      const location = Location.fetch(location_key)
      this.room_user_names.forEach(user_name => {
        const loc = this.user_name_to_initial_location(user_name)
        if (loc) {
          if (loc.key === location.key) {
            this.medal_add_to_user(user_name, plus)
          }
        }
      })
    },

    // /medal-user コマンド用
    // medal_user_name に対して plus だけ加算するように命令する
    medal_add_to_user(user_name, plus) {
      this.medal_add_to_user_share(user_name, plus)
    },
    medal_add_to_user_share(user_name, plus) {
      this.clog(`medal_add_to_user_share(${Gs2.i(user_name)}, ${Gs2.i(plus)})`)
      const params = {
        medal_user_name: user_name, // 誰に
        acquire_medal_plus: plus,   // これだけ加算する
      }
      this.ac_room_perform("medal_add_to_user_share", params)
    },
    medal_add_to_user_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      if (params.medal_user_name === this.user_name) {    // 自分だったら
        this.medal_add_to_self(params.acquire_medal_plus) // 指示されたぶんだけ加算する (そしてBC)
      }
    },
  },
}
