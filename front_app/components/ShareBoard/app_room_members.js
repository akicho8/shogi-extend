import _ from "lodash"
import dayjs from "dayjs"

import { IntervalRunner } from '@/components/models/interval_runner.js'

const ALIVE_NOTIFY_INTERVAL = 60      // N秒ごとに存在を通知する
const ALIVE_SEC             = 60*1.25 // N秒未満なら活発とみなして青くする
const KILL_SEC              = 60*3    // 通知がN秒前より古いユーザーは破棄

// const ALIVE_NOTIFY_INTERVAL = 5
// const ALIVE_SEC          = 10
// const KILL_SEC            = 20

const FAKE_P = false

export const app_room_members = {
  data() {
    return {
      member_infos: [],
      member_bc_interval_runner: new IntervalRunner(this.member_bc_interval_callback, {early: true, interval: ALIVE_NOTIFY_INTERVAL}),
      user_age: 0,              // 生存通知を送信した回数
      room_joined_at: null,     // 部屋に接続した時間(ms)
    }
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

    // 初めて接続したときの時間を room_joined_at に入れる
    // そうすると room_joined_at desc で古参順になる
    member_room_connected() {
      if (this.blank_p(this.room_joined_at)) {
        this.room_joined_at = dayjs().valueOf()
      }
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
        room_joined_at: this.room_joined_at,
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
      if (this.development_p && FAKE_P) {
        const room_joined_at = dayjs().valueOf()
        this.member_infos = ["alice", "bob", "carol", "dave", "ellen"].map((e, i) => ({
          performed_at: dayjs().valueOf(),
          user_age: 1,
          room_joined_at: room_joined_at + i,
          from_user_code: i,
          from_user_name: e,
        }))
      }

      if (true) {
        this.member_infos = _.orderBy(this.member_infos, "performed_at", "desc")  // 情報が新しいもの順に並べてから
        this.member_infos = _.uniqBy(this.member_infos, "from_user_code")         // ユーザーの重複を防ぐ(新しい方を採取できる)

        this.member_infos = this.member_infos_find_all_newest(this.member_infos)  // 通知が来た時間が最近の人だけを採取する
        // this.member_infos = _.orderBy(this.member_infos, "from_user_code", "asc") // 順序固定のためにユーザーコードで並べる(ランダムな固定)

        if (false) {
          // 自分の名前と同じ名前で入ってきたことがわからず、イタズラで勝手に操作されると、本人はホラーに感じる
          this.member_infos = _.uniqBy(this.member_infos, "from_user_name")         // ユーザー名が重複するのを防ぐ (再接続したとき不自然に見えるのを防ぐため)
        } else {
          // 自分の名前と同じ名前で入ってきたときなんとなく状況がわかる
        }

        // this.member_infos = _.orderBy(this.member_infos, ["user_age", "revision"], ["desc", "desc"]) // 順序固定のために年寄順に並べる(同じ場合はrevision順)
        // this.member_infos = _.orderBy(this.member_infos, ["from_user_name"], ["asc"]) // 順序固定のために名前順

        this.member_infos = _.orderBy(this.member_infos, ["room_joined_at"], ["asc"]) // 上から古参順に並べる
      }
    },

    // 通知が来た日時が最近の人だけを採取する
    member_infos_find_all_newest(list) {
      return list.filter(e => this.member_elapsed_sec(e) < KILL_SEC)
    },

    // 生きているか？
    member_alive_p(e) {
      return this.member_elapsed_sec(e) < ALIVE_SEC
    },
    // 寝ているか？
    member_sleep_p(e) {
      return !this.member_alive_p(e)
    },

    // 通達があってからの経過秒数
    member_elapsed_sec(e) {
      return (dayjs().valueOf() - e.performed_at) / 1000
    },

    member_add_test() {
      this.member_bc_interval_runner.restart()
    },
  },
  computed: {
    name_uniqued_member_infos() {
      return _.uniqBy(this.member_infos, "from_user_name")
    },
  },
}
