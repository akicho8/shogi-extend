import { Location } from 'shogi-player/src/location.js'
import numeral from "numeral"

export default {
  data: function() {
    // console.log("DEBUG", "data", "think_counter", parseInt(localStorage.getItem(chat_room_app_params.chat_room.id) || 0) + 3)
    return {
      clock_counts: chat_room_app_params.chat_room.clock_counts,
      think_counter: parseInt(localStorage.getItem(chat_room_app_params.chat_room.id) || 0) + 3, // リロードしたときに戻す。ペナルティとして3秒進める
    }
  },

  created() {
    console.log("DEBUG", "created", "think_counter", this.think_counter)

    setInterval(() => {
      if (this.thinking_p) {
        this.think_counter_set(this.think_counter + 1)
        if (this.current_rest_counter === 0) {
          this.game_end_time_up_trigger()
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
    // 指定手番(location_key)の残り秒数
    rest_counter(location_key) {
      let v = this.limit_seconds - this.total_time(location_key)
      if (this.current_location.key === location_key) {
        v -= this.think_counter
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
      let str = numeral(this.rest_counter(location.key)).format("00:00:00") // 0:00:00 になってしまう
      str = str.replace(/^0:/, "")
      return location.name + `<span class="digit_font">${str}</span>`
    },

    think_counter_reset() {
      this.think_counter_set(0)
    },

    think_counter_set(v) {
      this.think_counter = v
      localStorage.setItem(chat_room_app_params.chat_room.id, v)
      // console.log("DEBUG", "think_counter_set", v)
    },
  },

  computed: {
    // 持ち時間項目一覧
    lifetime_infos() {
      return lobby_app_params.lifetime_infos
    },

    // 選択中の持ち時間項目
    current_lifetime_info() {
      return _.find(this.lifetime_infos, (e) => e.key === this.current_lifetime_key)
    },

    // 持ち時間
    limit_seconds() {
      return this.current_lifetime_info["limit_seconds"]
    },

    // 現在の手番の人の残り時間
    current_rest_counter() {
      if (!this.current_location) {
        return 0
      }
      return this.rest_counter(this.current_location.key)
    },
  },
}
