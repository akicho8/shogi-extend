// データ構造
//   match_record              : { win_count: 0, lose_count: 0, }
//   users_match_record        : { alice: { win_count: 0, lose_count: 0, } }
//   users_match_record_master : { alice: { win_count: 0, lose_count: 0, } }

import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import { XprofileDecorator } from "./xprofile_decorator.js"

export const mod_xprofile = {
  data() {
    return {
      xprofile_loaded: false,          // DB から復元したら true にする
      users_match_record_master: {}, // 名前がキーで値が個数。みんなの個数が入っている。{ alice: {win_count: 0, lose_count: 0} }
    }
  },
  methods: {
    xprofile_entry() {
      this.xprofile_loaded = false
      this.users_match_record_master = {}
    },
    xprofile_leave() {
      this.xprofile_entry()
    },

    //////////////////////////////////////////////////////////////////////////////// 初回は DB から配布する

    xprofile_reload() {
      this.xprofile_loaded = false
      this.xprofile_load()
    },
    xprofile_load() {
      Gs.assert_present(this.user_name)

      if (!this.xprofile_loaded) {
        this.ac_room_perform("xprofile_load", {xprofile_reqeust: this.user_name})
      }
    },
    xprofile_load_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.xprofile_loaded = true
      }
      this.xprofile_dist_data_receive(params)
    },

    //////////////////////////////////////////////////////////////////////////////// 持っている情報を配布する。クライアント → 全員

    xprofile_dist() {
      Gs.assert_present(this.user_name)
      if (this.xprofile_dist_data) {
        this.ac_room_perform("xprofile_dist", this.xprofile_dist_data)
      }
    },
    xprofile_dist_broadcasted(params) {
      this.xprofile_dist_data_receive(params)
    },
    xprofile_dist_data_receive(params) {
      Gs.assert_kind_of_hash(params.users_match_record)
      this.users_match_record_master = { ...this.users_match_record_master, ...params.users_match_record }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // Helper
    xprofile_decorator_by_name(user_name) {
      return new XprofileDecorator(user_name, this.users_match_record_master[user_name])
    },
  },
  computed: {
    match_record() {
      return this.users_match_record_master[this.user_name]
    },
    xprofile_dist_data() {
      if (this.match_record) {
        return { users_match_record: { [this.user_name]: this.match_record } }
      }
    },
  },
}
