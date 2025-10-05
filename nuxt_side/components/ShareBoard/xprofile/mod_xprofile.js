// データ構造
//   match_record              : { win_count: 0, lose_count: 0, }
//   users_match_record        : { alice: { win_count: 0, lose_count: 0, } }
//   users_match_record_master : { alice: { win_count: 0, lose_count: 0, } }
//
// 実行の流れ
//   xprofile_entry  : 入室
//     xprofile_load : DBから取得(入室直後のみ)
//     xprofile_share : 他者が入室するたびに配布
//   xprofile_leave  : 退室
//
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
    // 入室直前の処理
    xprofile_entry() {
      this.xprofile_loaded = false
      this.users_match_record_master = {}
    },
    // 退出直前の処理
    xprofile_leave() {
      this.xprofile_entry()
    },

    //////////////////////////////////////////////////////////////////////////////// 初回は DB から配布する

    // 強制的にDBから読み出す
    xprofile_reload() {
      this.xprofile_loaded = false
      this.xprofile_load()
    },

    // 入室直後の処理
    xprofile_load() {
      Gs.assert_present(this.user_name)

      if (!this.xprofile_loaded) {
        this.ac_room_perform("xprofile_load", {reqeust_user_name: this.user_name})
      }
    },
    xprofile_load_broadcasted(params) {
      if (this.received_from_self(params)) {
        this.xprofile_loaded = true
      }
      this.xprofile_share_data_receive(params)
    },

    //////////////////////////////////////////////////////////////////////////////// 持っている情報を配布する。クライアント → 全員

    // 他の人が入室すると自分の情報を配る
    xprofile_share() {
      Gs.assert_present(this.user_name)
      if (this.xprofile_share_data) {
        this.ac_room_perform("xprofile_share", this.xprofile_share_data)
      }
    },
    xprofile_share_broadcasted(params) {
      this.xprofile_share_data_receive(params)
    },
    xprofile_share_data_receive(params) {
      if (params) {
        Gs.assert_kind_of_hash(params.users_match_record)
        this.users_match_record_master = { ...this.users_match_record_master, ...params.users_match_record }
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // Helper
    xprofile_decorator_by_name(user_name) {
      return new XprofileDecorator(user_name, this.users_match_record_master[user_name])
    },
  },
  computed: {
    // { win_count: 0, lose_count: 0 } または null
    match_record() {
      return this.users_match_record_master[this.user_name]
    },

    // 他の人に送る内容
    xprofile_share_data() {
      if (this.match_record) {
        return { users_match_record: { [this.user_name]: this.match_record } }
      }
    },
  },
}
