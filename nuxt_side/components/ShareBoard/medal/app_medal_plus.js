// チャット内コマンドでのメダル操作(なくてもよい)

import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export const app_medal_plus = {
  data() {
    return {
    }
  },
  mounted() {
  },
  methods: {
    medal_add_to_user(medal_user_name, acquire_medal_plus) {
      this.medal_add_to_user_share(medal_user_name, acquire_medal_plus)
    },

    medal_add_to_user_share(medal_user_name, acquire_medal_plus) {
      const params = {
        medal_user_name: medal_user_name,       // 誰に
        acquire_medal_plus: acquire_medal_plus, // これだけ加算する
      }
      this.ac_room_perform("medal_add_to_user_share", params)
    },

    medal_add_to_user_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      if (params.medal_user_name === this.user_name) {  // 自分だったら加算する
        this.medal_add_to_self(params.acquire_medal_plus)
      }
    },
  },
  computed: {
  },
}
