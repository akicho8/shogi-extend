// チャット内コマンドでのバッジ操作(なくてもよい)

import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export const mod_badge_plus = {
  methods: {
    // /badge-team コマンド用
    // チーム毎に一括でバッジ付与したいときに使う
    // location_key 側のチームの人たちに加算するように伝える
    // あくまで加算は本人に行ってもらう
    badge_add_to_team(location_key, plus) {
      const location = Location.fetch(location_key)
      this.room_user_names.forEach(user_name => {
        const loc = this.user_name_to_initial_location(user_name)
        if (loc) {
          if (loc.key === location.key) {
            this.badge_add_to_user(user_name, plus)
          }
        }
      })
    },

    // /badge-user コマンド用
    // badge_user_name に対して plus だけ加算するように命令する
    badge_add_to_user(user_name, plus) {
      this.badge_add_to_user_share(user_name, plus)
    },
    badge_add_to_user_share(user_name, plus) {
      this.clog(`badge_add_to_user_share(${Gs.i(user_name)}, ${Gs.i(plus)})`)
      const params = {
        badge_user_name: user_name, // 誰に
        acquire_badge_plus: plus,   // これだけ加算する
      }
      this.ac_room_perform("badge_add_to_user_share", params)
    },
    badge_add_to_user_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      if (params.badge_user_name === this.user_name) {    // 自分だったら
        this.badge_add_to_self(params.acquire_badge_plus) // 指示されたぶんだけ加算する (そしてBC)
      }
    },
  },
}
