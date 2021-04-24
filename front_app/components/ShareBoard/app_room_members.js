import _ from "lodash"
import dayjs from "dayjs"

import { IntervalRunner } from '@/components/models/interval_runner.js'

const ALIVE_NOTIFY_INTERVAL = 60      // N秒ごとに存在を通知する
const ACTIVE_LIMIT          = 60*1.25 // N秒以内なら活発とみなして青くする
const MEMBER_TTL            = 60*2    // 通知がN秒前より古いユーザーは破棄
const FAKE_P = true

export const app_room_members = {
  data() {
    return {
      member_infos: [],
      member_bc_interval_runner: new IntervalRunner(this.member_bc_interval_callback, {early: true, interval: ALIVE_NOTIFY_INTERVAL}),
      user_age: 0,
    }
  },

  beforeMount() {
  },

  beforeDestroy() {
    if (this.member_bc_interval_runner) {
      this.member_bc_interval_runner.stop()
    }
  },

  methods: {
    member_infos_clear() {
      this.member_infos = []
    },

    member_bc_interval_callback() {
      this.debug_alert("member_bc_interval_callback")
      this.user_age += 1
      this.member_info_share()
    },

    // 自分が存在することをみんなに伝える
    member_info_share() {
      this.ac_room_perform("member_info_share", {
        user_age: this.user_age,
      }) // --> app/channels/share_board/room_channel.rb
    },

    // 誰かが存在することが伝えられた
    member_info_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 誰かが存在することを自分に伝えられた
      } else {
        // 他の人が存在することを自分に伝えられた
      }
      this.member_add(params)
    },

    member_add(params) {
      this.member_infos.push(params)
      this.member_infos_normalize()
    },

    // 処理順序重要
    member_infos_normalize() {
      this.member_infos = _.orderBy(this.member_infos, "performed_at", "desc")  // 新しいもの順に並べてから
      this.member_infos = _.uniqBy(this.member_infos, "from_user_code")         // ユーザーの重複を防ぐ(新しい方を採取できる)

      this.member_infos = this.member_infos_find_all_newest(this.member_infos)  // 通知が来た時間が最近の人だけを採取する
      // this.member_infos = _.orderBy(this.member_infos, "from_user_code", "asc") // 順序固定のためにユーザーコードで並べる
      this.member_infos = _.uniqBy(this.member_infos, "from_user_name")         // ユーザー名が重複するのを防ぐ (再接続したとき不自然に見えるのを防ぐため)
      this.member_infos = _.orderBy(this.member_infos, "user_age", "desc")      // 順序固定のために年寄順に並べる

      if (this.development_p && FAKE_P) {
        // return [
        //   { enabled_p: true, order_index: null, user_name: "alice", },
        //   { enabled_p: true, order_index: null, user_name: "bob",   },
        //   { enabled_p: true, order_index: null, user_name: "carol", },
        //   { enabled_p: true, order_index: null, user_name: "dave",  },
        //   { enabled_p: true, order_index: null, user_name: "ellen", },
        // ]
        this.member_infos = [
          { performed_at: dayjs().unix(), user_age: 1, from_user_code: 1, from_user_name: "alice", },
          { performed_at: dayjs().unix(), user_age: 1, from_user_code: 2, from_user_name: "bob",   },
          { performed_at: dayjs().unix(), user_age: 1, from_user_code: 3, from_user_name: "carol", },
          { performed_at: dayjs().unix(), user_age: 1, from_user_code: 4, from_user_name: "dave",  },
          { performed_at: dayjs().unix(), user_age: 1, from_user_code: 5, from_user_name: "ellen", },
        ]
      }
    },

    // 通知が来た日時が最近の人だけを採取する
    member_infos_find_all_newest(list) {
      return list.filter(e => this.member_elapsed_second(e) <= MEMBER_TTL)
    },

    // 生きているか？
    member_alive_p(e) {
      return this.member_elapsed_second(e) <= ACTIVE_LIMIT
    },

    // 通達があってからの経過秒数
    member_elapsed_second(e) {
      return dayjs().unix() - e.performed_at
    },

    member_add_test() {
      this.member_bc_interval_runner.restart()
    },
  },
  components: {
    name_uniqued_member_infos() {
      return _.uniqBy(this.member_infos, "from_user_name")
    },
  },
}
