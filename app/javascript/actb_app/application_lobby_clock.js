import { TimeSupport } from "./models/time_support.js"

export const application_lobby_clock = {
  data() {
    return {
      lrt_id: null,                 // setIntervalのID

      lobby_clock_mode:       null, // 現在の状態
      lobby_clock_mode_count: null, // 切り替わってからの時間
    }
  },
  created() {
    this.lobby_clock_mode = this.lobby_clock_mode_fetch()
    this.lobby_clock_mode_count = 1 // トリガーを発生させないように1から開始する
  },
  methods: {
    // 開催期間中か？
    lobby_clock_mode_fetch() {
      if (this.app.config.lobby_clock_restrict_p) {
        if (TimeSupport.time_ranges_active_p(this.app.config.lobby_clock_restrict_ranges)) {
          return "active"
        } else {
          return "inactive"
        }
        return TimeSupport.time_ranges_active_p(this.app.config.lobby_clock_restrict_ranges)
      } else {
        // 時間が有効でなければ常に開催中
        return "active"
      }
    },

    //////////////////////////////////////////////////////////////////////////////// lrt = Lobby Refresh Timer
    lrt_start() {
      this.lrt_stop()
      this.lrt_id = setInterval(this.lrt_processing, 1000)
    },

    lrt_stop() {
      if (this.lrt_id) {
        clearInterval(this.lrt_id)
        this.lrt_id = null
      }
    },

    lrt_restart() {
      this.lrt_stop()
      this.lrt_start()
    },

    lrt_processing() {
      // this.$forceUpdate()       // ←動いてない

      const new_value = this.lobby_clock_mode_fetch()
      if (new_value !== this.lobby_clock_mode) {
        this.lobby_clock_mode = new_value
        this.lobby_clock_mode_count = 0
      }

      if (this.lobby_clock_mode === "active") {
        if (this.lobby_clock_mode_count === 0) {
          this.ok_notice("バトルの時間になりました")
        }
      }

      if (this.lobby_clock_mode === "inactive") {
        if (this.lobby_clock_mode_count === 0) {
          this.ok_notice("バトルの時間はおわりです")
        }
      }

      this.lobby_clock_mode_count += 1
    },
    ////////////////////////////////////////////////////////////////////////////////
  },
}
