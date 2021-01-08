import _ from "lodash"
import dayjs from "dayjs"

import { IntervalRunner } from '@/components/models/IntervalRunner.js'

const ALIVE_NOTIFY_INTERVAL = 60  // N秒ごとに存在を通知する
const MEMBER_TTL            = 120 // 通知がN秒前より古いユーザーは破棄

export const app_room_members = {
  data() {
    return {
      member_infos: [],
      member_bc_interval_runner: new IntervalRunner(this.member_bc_interval_callback, {early: true, interval: ALIVE_NOTIFY_INTERVAL}),
      user_age: 0,
    }
  },

  mounted() {
    // const foo = [
    //   {id: 1, name: "a"},
    //   {id: 2, name: "a"},
    // ]
    // console.log(_.orderBy(foo, "id", "desc"))
    // console.log(_.orderBy(foo, "id", "asc"))
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
    member_share_broadcasted(params) {
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
      this.member_infos = _.orderBy(this.member_infos, "performed_at", "desc")  // 新しいもの順に並べる
      this.member_infos = _.uniqBy(this.member_infos, "from_user_code")         // ユーザーの重複を防ぐ(新しい方を採取する)
      this.member_infos = this.member_infos_find_all_newest(this.member_infos)  // 通知が来た時間が最近の人だけを採取する
      // this.member_infos = _.orderBy(this.member_infos, "from_user_code", "asc") // 順序固定のためにユーザーコードで並べる
      this.member_infos = _.orderBy(this.member_infos, "user_age", "desc")      // 順序固定のために年寄順に並べる
    },

    // 通知が来た日時が最近の人だけを採取する
    member_infos_find_all_newest(list) {
      const now = dayjs().unix()
      return list.filter(e => {
        const v = now - e.performed_at
        if (this.development_p) {
          this.clog(`${now} - ${e.performed_at} = ${v}`)
        }
        return v <= MEMBER_TTL
      })
    },

    member_add_test() {
      this.member_bc_interval_runner.restart()
    },
  },
}
