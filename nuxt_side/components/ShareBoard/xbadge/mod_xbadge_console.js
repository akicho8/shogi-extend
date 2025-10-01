// チャット内コマンドでのバッジ操作(なくてもよい)

import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export const mod_xbadge_console = {
  methods: {
    // /xbadge-team コマンド用
    // チーム毎に一括でバッジ付与したいときに使う
    // location_key 側のチームの人たちに加算するように伝える
    // あくまで加算は本人に行ってもらう
    xbadge_add_to_team(location_key, plus) {
      const location = Location.fetch(location_key)
      this.room_user_names.forEach(user_name => {
        const loc = this.user_name_to_initial_location(user_name)
        if (loc) {
          if (loc.key === location.key) {
            this.xbadge_add_to_user(user_name, plus)
          }
        }
      })
    },

    // /xbadge-user コマンド用
    // xbadge_user_name に対して plus だけ加算するように命令する
    xbadge_add_to_user(user_name, plus) {
      this.xbadge_add_to_user_share(user_name, plus)
    },
    xbadge_add_to_user_share(user_name, plus) {
      this.clog(`xbadge_add_to_user_share(${Gs.i(user_name)}, ${Gs.i(plus)})`)
      const params = {
        xbadge_user_name: user_name, // 誰に
        xbadge_plus: plus,   // これだけ加算する
      }
      this.ac_room_perform("xbadge_add_to_user_share", params)
    },
    xbadge_add_to_user_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      if (params.xbadge_user_name === this.user_name) {    // 自分だったら
        this.xbadge_add_to_self(params.xbadge_plus) // 指示されたぶんだけ加算する (そしてBC)
      }
    },
  },
}
