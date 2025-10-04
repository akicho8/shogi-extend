// データ構造
//   match_record              : { win_count: 0, lose_count: 0, }
//   users_match_record        : { alice: { win_count: 0, lose_count: 0, } }
//   users_match_record_master : { alice: { win_count: 0, lose_count: 0, } }

import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { XbadgeDecorator } from "./xbadge_decorator.js"

export const mod_xbadge = {
  data() {
    return {
      xbadge_loaded: false,          // DB から復元したら true にする
      users_match_record_master: {}, // 名前がキーで値が個数。みんなの個数が入っている。{ alice: {win_count: 0, lose_count: 0} }
    }
  },
  methods: {
    xbadge_entry() {
      this.xbadge_loaded = false
      this.users_match_record_master = {}
    },
    xbadge_leave() {
      this.xbadge_entry()
    },

    //////////////////////////////////////////////////////////////////////////////// 初回は DB から配布する

    xbadge_reload() {
      this.xbadge_loaded = false
      this.xbadge_load()
    },
    xbadge_load() {
      Gs.assert_present(this.user_name)

      if (!this.xbadge_loaded) {
        this.ac_room_perform("xbadge_load", {xbadge_reqeust: this.user_name})
      }
    },
    xbadge_load_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.xbadge_loaded = true
      }
      this.xbadge_dist_data_receive(params)
    },

    //////////////////////////////////////////////////////////////////////////////// 持っている情報を配布する。クライアント → 全員

    xbadge_dist() {
      Gs.assert_present(this.user_name)
      if (this.xbadge_dist_data) {
        this.ac_room_perform("xbadge_dist", this.xbadge_dist_data)
      }
    },
    xbadge_dist_broadcasted(params) {
      this.xbadge_dist_data_receive(params)
    },
    xbadge_dist_data_receive(params) {
      Gs.assert_kind_of_hash(params.users_match_record)
      this.users_match_record_master = { ...this.users_match_record_master, ...params.users_match_record }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // Helper
    xbadge_decorator_by_name(user_name) {
      return new XbadgeDecorator(user_name, this.users_match_record_master[user_name])
    },
  },
  computed: {
    match_record() {
      return this.users_match_record_master[this.user_name]
    },
    xbadge_dist_data() {
      if (this.match_record) {
        return { users_match_record: { [this.user_name]: this.match_record } }
      }
    },
  },
}
