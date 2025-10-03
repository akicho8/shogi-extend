import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { XbadgeDecorator } from "./xbadge_decorator.js"

export const mod_xbadge = {
  data() {
    return {
      xbadge_loaded: false,   // DB から復元したら true にする
      xbadge_counts_hash: {}, // 名前がキーで値が個数。みんなの個数が入っている。
    }
  },
  methods: {
    xbadge_init() {
      this.xbadge_loaded = false
      this.xbadge_counts_hash = {}
    },
    xbadge_destroy() {
      this.xbadge_init()
    },

    //////////////////////////////////////////////////////////////////////////////// 初回は DB から配布する

    xbadge_reload() {
      this.xbadge_loaded = false
      this.xbadge_load()
    },
    xbadge_load() {
      Gs.assert_present(this.user_name)

      if (!this.xbadge_loaded) {
        this.ac_room_perform("xbadge_load", {xbadge_user_name: this.user_name})
      }
    },
    xbadge_load_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.xbadge_loaded = true
      }
      this.xbadge_dist_hash_receive(params)
    },

    //////////////////////////////////////////////////////////////////////////////// 持っている情報を配布する

    // 自分のバッジ数を全員に伝える
    xbadge_dist() {
      Gs.assert_present(this.user_name)
      if (this.xbadge_dist_hash) {
        this.ac_room_perform("xbadge_dist", this.xbadge_dist_hash)
      }
    },
    xbadge_dist_broadcasted(params) {
      this.xbadge_dist_hash_receive(params)
    },
    xbadge_dist_hash_receive(attrs) {
      if (attrs) {
        this.$set(this.xbadge_counts_hash, attrs.xbadge_user_name, attrs.xbadge_count) // これで画面に星の数が反映される
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // Helper
    xbadge_decorator_by_name(user_name) {
      return new XbadgeDecorator(this.xbadge_counts_hash, user_name)
    },
  },
  computed: {
    xbadge_my_count() {
      return this.xbadge_counts_hash[this.user_name]
    },
    xbadge_dist_hash() {
      if (this.xbadge_my_count != null) {
        return {
          xbadge_user_name: this.user_name,
          xbadge_count: this.xbadge_my_count,
        }
      }
    },
  },
}
