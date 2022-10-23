import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"
import { MedalVo } from "./medal_vo.js"
import _ from "lodash"

const ACQUIRE_MEDAL_COUNT_PERSISTED_P = true // 獲得メダル数を保持するか？

export const app_medal = {
  data() {
    return {
      medal_counts_hash: {},
    }
  },
  methods: {
    // (部屋に入るタイミングで)メダル獲得数を取り込む
    medal_init() {
      this.medal_counts_hash[this.user_name] = this.acquire_medal_count
      this.tl_add("メダル", `${this.acquire_medal_count} で復帰`, this.medal_counts_hash)
    },

    // (更新の通知を受信したタイミング)もし自分が含まれていたら(localStorageを)更新する
    medal_persisted() {
      const count = this.medal_counts_hash[this.user_name]
      if (count != null) {
        if (ACQUIRE_MEDAL_COUNT_PERSISTED_P) {
          this.tl_add("メダル", `更新 ${this.acquire_medal_count} --> ${count}`, this.medal_counts_hash)
          this.acquire_medal_count = count
        }
      }
    },

    // チーム毎に一括でメダル付与
    // win_location_key 側のチームのみんなを count する
    medal_add_to_team(target_location_key, count = 1) {
      const target_location = Location.fetch(target_location_key)
      const hv = _.clone(this.medal_counts_hash) // ここでは medal_counts_hash を破壊しない
      this.room_user_names.forEach(e => {
        const user_location = this.user_name_to_initial_location(e)
        if (user_location) {
          if (user_location.key === target_location.key) {
            hv[e] = (hv[e] ?? 0) + count
          }
        }
      })
      this.medal_counts_hash_share(hv)
    },

    // 指定のユーザーだけにこっそりメダル付与 (デバッグ用)
    medal_add_to_user(user_name, count = 1) {
      if (this.present_p(user_name)) {
        const hv = _.clone(this.medal_counts_hash) // ここでは medal_counts_hash を破壊しない
        Gs2.__assert__(user_name, "user_name")
        hv[user_name] = (hv[user_name] ?? 0) + count
        this.medal_counts_hash_share(hv)
      }
    },

    // サイドバー用
    sidebar_medal_add_to_user_handle(count) {
      this.$sound.play_click()
      this.medal_add_to_user(this.user_name, count)
    },

    // 共有
    medal_counts_hash_share(medal_counts_hash) {
      const params = {medal_counts_hash: medal_counts_hash}
      if (this.ac_room) {
        this.ac_room_perform("medal_counts_hash_share", params)
      } else {
        this.medal_counts_hash_share_broadcasted({
          ...this.ac_room_perform_default_params(),
          ...params,
        })
      }
    },
    medal_counts_hash_share_broadcasted(params) {
      this.receive_medal_counts_hash(params.medal_counts_hash)
    },
    receive_medal_counts_hash(medal_counts_hash) {
      Gs2.__assert__(medal_counts_hash, "medal_counts_hash")
      this.medal_counts_hash = medal_counts_hash // 自分もみんなと同じようにここだけで更新する
      this.medal_persisted()                     // 自分のだけをlocalStorageに保存
    },

    // Helper
    medal_vo_by_name(user_name) {
      return new MedalVo(this.medal_counts_hash, user_name)
    },
  },
}
