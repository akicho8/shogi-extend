import { Location } from 'shogi-player/src/location'
import { LifetimeInfo } from "./lifetime_info"
import numeral from "numeral"

export default {
  data() {
    // console.log("DEBUG", "data", "clock_counter", parseInt(localStorage.getItem(js_battle.id) || 0) + 3)
    return {
      clock_counts: js_battle.clock_counts,
      clock_counter: parseInt(localStorage.getItem(js_battle.id) || 3), // リロードしたときに戻す。ペナルティとして3秒進める
      countdown_flags: js_battle.countdown_flags,
      time_up_trigger_count: 0, // time_up_trigger() 実行回数制限用
    }
  },

  created() {
    console.log("DEBUG", "created", "clock_counter", this.clock_counter)

    setInterval(() => {
      if (this.thinking_p) {
        this.clock_counter_inc()

        if (this.current_location) {
          if (!this.second_p) {
            if (this.current_rest_counter1 <= 0) {
              this.countdown_flag_on()
            }
          } else {
            if (this.current_rest_counter2 <= 0) {
              this.time_up_trigger()
            }
          }
        }
      }
    }, 1000)
  },

  destroyed() {
    console.log("DEBUG", "destroyed")
  },

  watch: {
  },

  methods: {
    // ゲーム終了(時間切れにより・生き残っている全員で送信)
    time_up_trigger() {
      if (this.member_p) {
        if (this.time_up_trigger_count === 0) {
          // ログが見やすいように1回だけコールする
          App.battle.time_up_trigger({membership_ids: this.__my_membership_ids, win_location_key: this.current_location.flip.key})
        }
        this.time_up_trigger_count += 1
      }
    },

    // 指定手番(location_key)の残り秒数
    rest_counter1(location_key) {
      let v = this.current_lifetime_info.limit_seconds - this.total_time(location_key)
      if (this.current_location.key === location_key) {
        v -= this.clock_counter
      }
      if (v < 0) {
        v = 0
      }
      return v
    },

    // 指定手番(location_key)の残り秒数
    rest_counter2(location_key) {
      let v = this.current_lifetime_info.byoyomi
      if (this.current_location.key === location_key) {
        v -= this.clock_counter
      }
      if (v < 0) {
        v = 0
      }
      return v
    },

    // 指定手番(location_key)のトータル使用時間
    total_time(location_key) {
      return _.reduce(this.clock_counts[location_key], (a, e) => a + e, 0)
    },

    // 指定手番(location_key)の残り時間の表示用
    time_format(location_key) {
      let location = Location.fetch(location_key)
      if (this.flip) {
        location = location.flip
      }

      if (!this.countdown_flags[location.key]) {
        const count1 = this.rest_counter1(location.key)
        let str = numeral(this.rest_counter1(location.key)).format("00:00:00") // 0:00:00 になってしまう
        str = str.replace(/^0:/, "")
        return location.name + `<span class="digit_font">${str}</span>`
      }

      const count2 = this.rest_counter2(location.key)
      return location.name + `<span class="digit_font">${count2}</span>`
    },

    clock_counter_inc() {
      this.clock_counter_set(this.clock_counter + 1)
    },

    clock_counter_reset() {
      this.clock_counter_set(0)
    },

    clock_counter_set(v) {
      this.clock_counter = v
      localStorage.setItem(js_battle.id, v)
    },

    countdown_flag_on() {
      this.countdown_flags[this.current_location.key] = true
      this.clock_counter_set(0)
      App.battle.countdown_flag_on(this.current_location.key)
    }
  },

  computed: {
    // 選択中の持ち時間項目
    current_lifetime_info() {
      return LifetimeInfo.fetch(this.current_lifetime_key)
    },

    current_platoon_info() {
      return PlatoonInfo.fetch(this.current_platoon_key)
    },

    second_p() {
      return this.countdown_flags[this.current_location.key]
    },

    current_rest_counter1() {
      return this.rest_counter1(this.current_location.key)
    },

    current_rest_counter2() {
      return this.rest_counter2(this.current_location.key)
    },
  },
}
