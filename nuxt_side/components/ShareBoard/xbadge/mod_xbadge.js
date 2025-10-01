import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { XbadgeDecorator } from "./xbadge_decorator.js"

export const mod_xbadge = {
  data() {
    return {
      xbadge_counts_hash: {}, // 名前がキーで値が個数。みんなの個数が入っている。
    }
  },
  methods: {
    // 起動時に名前が復元できていればバッジ獲得数を表示に反映する
    // これは this.user_name を設定した直後に自動的に呼ぶ
    xbadge_share_when_user_name_update() {
      this.clog(`xbadge_share_when_user_name_update()`)
      if (Gs.present_p(this.user_name)) {
        this.xbadge_share_data_receive(this.xbadge_share_data)
      }
    },

    // 自分が勝った側 (win_location_key) のメンバーであれば +plus する
    xbadge_add_to_self_if_win(location_key, plus) {
      const location = Location.fetch(location_key)
      if (this.my_location) {
        if (this.my_location.key === location.key) {
          this.xbadge_add_to_self(plus)
        }
      }
    },

    // 自分のバッジ数を +plus してみんなに伝える
    xbadge_add_to_self(plus) {
      this.clog(`xbadge_add_to_self(${plus})`)
      this.xbadge_count += plus
      this.xbadge_count_share()
    },

    // 自分のバッジ数を +plus してみんなに伝える(サイドバー用)
    xbadge_add_to_self_handle(plus) {
      this.sfx_click()
      this.xbadge_add_to_self(plus)
    },

    // 自分のバッジ数を(自分を含めて)みんなに伝える
    xbadge_count_share() {
      if (Gs.blank_p(this.user_name)) {
        return
      }
      this.clog(`xbadge_count_share`)
      if (this.ac_room) {
        this.ac_room_perform("xbadge_count_share", this.xbadge_share_data)
      } else {
        this.xbadge_count_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...this.xbadge_share_data,
        })
      }
    },
    xbadge_count_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      this.xbadge_share_data_receive(params)
    },
    xbadge_share_data_receive(params) {
      this.clog(`xbadge_share_data_receive(${Gs.i(params)})`)
      Gs.assert(Gs.present_p(params.xbadge_user_name), "Gs.present_p(params.xbadge_user_name)")
      Gs.assert(Gs.present_p(params.xbadge_count), "Gs.present_p(params.xbadge_count)")
      this.$set(this.xbadge_counts_hash, params.xbadge_user_name, params.xbadge_count) // これで画面に星の数が反映される
    },

    // Helper
    xbadge_decorator_by_name(user_name) {
      return new XbadgeDecorator(this.xbadge_counts_hash, user_name)
    },
  },
  computed: {
    // 部屋に入ったときや更新するときはこれを送る
    xbadge_share_data() {
      return {
        xbadge_user_name: this.user_name,               // 誰が
        xbadge_count: this.xbadge_count, // 何個持っている
      }
    },
  },
}
