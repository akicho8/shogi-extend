import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { BadgeDecorator } from "./badge_decorator.js"

export const mod_badge = {
  data() {
    return {
      badge_counts_hash: {}, // 名前がキーで値が個数。みんなの個数が入っている。
    }
  },
  methods: {
    // 起動時に名前が復元できていればバッジ獲得数を表示に反映する
    // これは this.user_name を設定した直後に自動的に呼ぶ
    badge_write() {
      this.clog(`badge_write()`)
      if (Gs.present_p(this.user_name)) {
        this.badge_share_data_receive(this.badge_share_data)
      }
    },

    // 自分が勝った側 (win_location_key) のメンバーであれば +plus する
    badge_add_to_self_if_win(location_key, plus) {
      const location = Location.fetch(location_key)
      if (this.my_location) {
        if (this.my_location.key === location.key) {
          this.badge_add_to_self(plus)
        }
      }
    },

    // 自分のバッジ数を +plus してみんなに伝える
    badge_add_to_self(plus) {
      this.clog(`badge_add_to_self(${plus})`)
      this.acquire_badge_count += plus
      this.acquire_badge_count_share()
    },

    // 自分のバッジ数を +plus してみんなに伝える(サイドバー用)
    badge_add_to_self_handle(plus) {
      this.sfx_click()
      this.badge_add_to_self(plus)
    },

    // 自分のバッジ数を(自分を含めて)みんなに伝える
    acquire_badge_count_share() {
      if (Gs.blank_p(this.user_name)) {
        return
      }
      this.clog(`acquire_badge_count_share`)
      if (this.ac_room) {
        this.ac_room_perform("acquire_badge_count_share", this.badge_share_data)
      } else {
        this.acquire_badge_count_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...this.badge_share_data,
        })
      }
    },
    acquire_badge_count_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      this.badge_share_data_receive(params)
    },
    badge_share_data_receive(params) {
      this.clog(`badge_share_data_receive(${Gs.i(params)})`)
      Gs.assert(Gs.present_p(params.badge_user_name), "Gs.present_p(params.badge_user_name)")
      Gs.assert(Gs.present_p(params.acquire_badge_count), "Gs.present_p(params.acquire_badge_count)")
      this.$set(this.badge_counts_hash, params.badge_user_name, params.acquire_badge_count) // これで画面に星の数が反映される
    },

    // Helper
    badge_decorator_by_name(user_name) {
      return new BadgeDecorator(this.badge_counts_hash, user_name)
    },
  },
  computed: {
    // 部屋に入ったときや更新するときはこれを送る
    badge_share_data() {
      return {
        badge_user_name: this.user_name,               // 誰が
        acquire_badge_count: this.acquire_badge_count, // 何個持っている
      }
    },
  },
}
