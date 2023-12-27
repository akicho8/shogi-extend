import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { MedalDecorator } from "./medal_decorator.js"

export const mod_medal = {
  data() {
    return {
      medal_counts_hash: {}, // 名前がキーで値が個数。みんなの個数が入っている。
    }
  },
  methods: {
    // 起動時に名前が復元できていればメダル獲得数を表示に反映する
    // これは this.user_name を設定した直後に自動的に呼ぶ
    medal_write() {
      this.clog(`medal_write()`)
      if (Gs.present_p(this.user_name)) {
        this.medal_share_data_receive(this.medal_share_data)
      }
    },

    // 自分が勝った側 (win_location_key) のメンバーであれば +plus する
    medal_add_to_self_if_win(location_key, plus) {
      const location = Location.fetch(location_key)
      if (this.my_location) {
        if (this.my_location.key === location.key) {
          this.medal_add_to_self(plus)
        }
      }
    },

    // 自分のメダル数を +plus してみんなに伝える
    medal_add_to_self(plus) {
      this.clog(`medal_add_to_self(${plus})`)
      this.acquire_medal_count += plus
      this.acquire_medal_count_share()
    },

    // 自分のメダル数を +plus してみんなに伝える(サイドバー用)
    medal_add_to_self_handle(plus) {
      this.$sound.play_click()
      this.medal_add_to_self(plus)
    },

    // 自分のメダル数を(自分を含めて)みんなに伝える
    acquire_medal_count_share() {
      if (Gs.blank_p(this.user_name)) {
        return
      }
      this.clog(`acquire_medal_count_share`)
      if (this.ac_room) {
        this.ac_room_perform("acquire_medal_count_share", this.medal_share_data)
      } else {
        this.acquire_medal_count_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...this.medal_share_data,
        })
      }
    },
    acquire_medal_count_share_broadcasted(params) {
      if (this.received_from_self(params)) {
      } else {
      }
      this.medal_share_data_receive(params)
    },
    medal_share_data_receive(params) {
      this.clog(`medal_share_data_receive(${Gs.i(params)})`)
      Gs.assert(Gs.present_p(params.medal_user_name), "Gs.present_p(params.medal_user_name)")
      Gs.assert(Gs.present_p(params.acquire_medal_count), "Gs.present_p(params.acquire_medal_count)")
      this.$set(this.medal_counts_hash, params.medal_user_name, params.acquire_medal_count) // これで画面に星の数が反映される
    },

    // Helper
    medal_decorator_by_name(user_name) {
      return new MedalDecorator(this.medal_counts_hash, user_name)
    },
  },
  computed: {
    // 部屋に入ったときや更新するときはこれを送る
    medal_share_data() {
      return {
        medal_user_name: this.user_name,               // 誰が
        acquire_medal_count: this.acquire_medal_count, // 何個持っている
      }
    },
  },
}
