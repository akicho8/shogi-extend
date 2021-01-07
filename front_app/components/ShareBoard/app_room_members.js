import _ from "lodash"
import dayjs from "dayjs"

import { IntervalRunner } from '@/components/models/IntervalRunner.js'

const NOTIFY_INTERVAL = 10
const NOTIFY_INTERVAL2 = 15

export const app_room_members = {
  data() {
    return {
      member_infos: [],
      member_notify_interval_runner: new IntervalRunner(this.step_next, {early: true, interval: NOTIFY_INTERVAL}),
    }
  },

  beforeDestroy() {
    this.member_notify_interval_runner.stop()
  },

  methods: {
    step_next() {
      this.member_share()
    },
    member_share() {
      this.ac_room_perform("member_share", {
      }) // --> app/channels/share_board/room_channel.rb
    },
    member_share_broadcasted(params) {
      if (params.from_user_code === this.user_code) {
        // 自分から自分へ
      } else {
        // this.attributes_set(params)
        // this.toast_ok(`タイトルを${params.member}に変更しました`)
      }
      this.member_add(params)
    },

    member_add(params) {
      this.member_infos.push(params)
      this.filtered_member_infos()
    },

    filtered_member_infos() {
      const t = dayjs().unix()
      this.member_infos = this.member_infos.filter(e => {
        const v = t - e.performed_at
        if (this.development_p) {
          this.clog(`${t} - ${e.performed_at} = ${v}`)
        }
        return v < NOTIFY_INTERVAL2
      })

      this.member_infos = _.uniqBy(this.member_infos, "from_user_code")    // ユーザーの重複を防ぐ
      // this.member_infos = _.orderBy(this.member_infos, "revision", "desc") // 古株順は揺れるのだめ
      this.member_infos = _.orderBy(this.member_infos, "from_user_code") // 古株順は揺れるのだめ
    },

    member_add_test() {
      // this.member_add({
      //   from_user_name: "あいうえおあいうえお",
      //   turn_offset: this.base.member_infos.length,
      //   performed_last_location_key: "white",
      //   sfen: "position startpos",
      //   performed_at: dayjs().unix(),
      // })
    },
  },
}
