import _ from "lodash"
import dayjs from "dayjs"

import { IntervalRunner } from '@/components/models/interval_runner.js'

const ALIVE_NOTIFY_INTERVAL = 60       // N秒ごとに存在を通知する
const ALIVE_SEC             = 60 + 8  // N秒未満なら活発とみなして青くする
const KILL_SEC              = 60 + 30 // 通知がN秒前より古いユーザーは破棄

// const ALIVE_NOTIFY_INTERVAL = 5
// const ALIVE_SEC          = 10
// const KILL_SEC            = 20

const FAKE_P = false

export const app_room_members = {
  data() {
    return {
      member_infos:   null, // 参加者たち
      room_joined_at: null, // 部屋に接続した時間(ms)
      alive_notice_count:       null, // 生存通知を送信した回数

      member_bc_interval_runner: new IntervalRunner(this.member_bc_interval_callback, {early: true, interval: ALIVE_NOTIFY_INTERVAL}),
    }
  },
  created() {
    this.member_infos_init()
  },

  beforeDestroy() {
    if (this.member_bc_interval_runner) {
      this.member_bc_interval_runner.stop()
    }
  },

  methods: {
    member_infos_init() {
      this.member_infos = []
    },

    // 接続するタイミングで初期化
    // room_joined_at は古参度でソートするため
    member_info_init() {
      this.alive_notice_count = 0
      this.room_joined_at = this.time_current_ms()
    },

    // インターバル実行の再スタートで即座にメンバー情報を反映する
    // 即座に member_bc_interval_callback を実行する
    member_info_bc_restart() {
      this.member_bc_interval_runner.restart()
    },

    member_bc_interval_callback() {
      this.member_info_share()
    },

    // 自分が存在することをみんなに伝える
    member_info_share() {
      if (!this.ac_room) {
        return
      }
      this.debug_alert("生存通知")
      this.tl_add("USER", "member_info_share")
      this.alive_notice_count += 1
      this.ac_room_perform("member_info_share", {
        alive_notice_count:  this.alive_notice_count,   // 通知した回数
        room_joined_at:      this.room_joined_at,       // 部屋に入った日時(古参比較用)
        window_active_count: this.window_active_count,  // Windowの状態
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
      const size = this.member_infos.length

      this.member_infos.push(params)
      this.member_infos_normalize()

      if (this.current_member_is_leader_p) {
        if (this.member_infos.length === size) {
          // 個数変化なし
        } else {
          // 個数変化あり
          this.ac_log("仲間一覧", this.member_infos.map(e => e.from_user_name))
        }
      }
    },

    // 処理順序重要
    member_infos_normalize() {
      if (this.development_p && FAKE_P) {
        const room_joined_at = this.time_current_ms()
        this.member_infos = ["alice", "bob", "carol", "dave", "ellen"].map((e, i) => ({
          performed_at: this.time_current_ms(),
          alive_notice_count: 1,
          room_joined_at: room_joined_at + i,
          from_user_code: i === 0 ? this.user_code : i,
          from_user_name: e,
          window_active_count: 1,
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

        // this.member_infos = _.orderBy(this.member_infos, ["alive_notice_count", "active_level"], ["desc", "desc"]) // 順序固定のために年寄順に並べる(同じ場合はactive_level順)
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
    member_disconnect_p(e) {
      return !this.member_alive_p(e)
    },

    // 通達があってからの経過秒数
    member_elapsed_sec(e) {
      return (this.time_current_ms() - e.performed_at) / 1000
    },
  },
  computed: {
    name_uniqued_member_infos() {
      return _.uniqBy(this.member_infos, "from_user_name")
    },

    // 一番上にいる人は自分か？
    // つまり最古参メンバーか？
    current_member_is_leader_p() {
      if (this.present_p(this.member_infos)) {
        return this.member_infos[0].from_user_code === this.user_code
      }
    },
  },
}
