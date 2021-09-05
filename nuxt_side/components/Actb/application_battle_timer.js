import dayjs from "dayjs"

const PRACTICE_MODE_MAGNIFICATION = 3

export const application_battle_timer = {
  data() {
    return {
      // 共通
      main_interval_id: null,
      main_interval_count: null,

      // シングルトン専用
      ops_interval_id: null,
      ops_interval_count: null,  // 1手指してからの秒数
      ops_interval_total: null, // 「わかった」してからのトータル秒数(かなり誤差あり)
    }
  },

  methods: {
    main_interval_start() {
      this.main_interval_clear()
      this.main_interval_count = 0
      this.main_interval_id = setInterval(this.main_interval_processing, 1000)
    },

    main_interval_clear() {
      if (this.main_interval_id) {
        clearInterval(this.main_interval_id)
        this.main_interval_id = null
      }
    },

    main_interval_processing() {
      if (this.current_strategy_key === "sy_marathon") {
        if (this.sub_mode === "sm4_tactic") {
          this.main_interval_count += 1
          if (this.main_rest_seconds === 0) {
            this.kotae_sentaku('timeout')
          }
        }
      }
      if (this.current_strategy_key === "sy_singleton") {
        if (this.sub_mode === "sm4_tactic") {
          if (this.x_mode === "x1_think") {
            this.main_interval_count += 1
            if (this.main_rest_seconds === 0) {
              if (this.leader_p) {
                this.kotae_sentaku('timeout') // [ONCE]
              }
            }
          }
        }
      }
      if (this.current_strategy_key === "sy_hybrid") {
        if (this.sub_mode === "sm4_tactic") {
          this.main_interval_count += 1
          if (this.main_rest_seconds === 0) {
            if (this.leader_p) {
              this.kotae_sentaku('timeout') // [ONCE]
            }
          }
        }
      }
    },

    //////////////////////////////////////////////////////////////////////////////// シングルトン専用

    // 最初に「わかった」したときだけのタイマー
    ops_interval_start_onece() {
      this.ops_interval_start()
      this.ops_interval_total = 0
    },

    // 操作するたびに繰替えされるタイマー
    ops_interval_start() {
      this.ops_interval_stop()
      this.ops_interval_count = 0
      this.ops_interval_id = setInterval(this.ops_interval_processing, 1000)
    },

    ops_interval_stop() {
      if (this.ops_interval_id) {
        clearInterval(this.ops_interval_id)
        this.ops_interval_id = null
      }
    },

    ops_interval_restart() {
      this.ops_interval_stop()
      this.ops_interval_start()
    },

    ops_interval_processing() {
      if (this.sub_mode === "sm4_tactic") {
        this.ops_interval_count += 1
        this.ops_interval_total += 1
        if (this.ops_rest_seconds === 0) {
          this.x2_play_timeout_handle()
        }
      }
    },
    ////////////////////////////////////////////////////////////////////////////////
  },

  computed: {
    ////////////////////////////////////////////////////////////////////////////////
    main_time_as_string() {
      let v = this.main_rest_seconds
      if (v < 1) {
        v = 1
      }
      return dayjs().startOf("year").set("seconds", v).format(this.main_time_dayjs_format)
    },
    main_time_dayjs_format() {
      if (this.main_rest_seconds < 60) {
        return "s"
      } else {
        return "m:ss"
      }
    },
    // 現在の変化する残り時間
    main_rest_seconds() {
      let v = (this.current_rule_info.time_limit_sec * this.time_mag) - this.main_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },

    //////////////////////////////////////////////////////////////////////////////// シングルトン専用

    ops_rest_seconds() {
      let v = (this.current_rule_info.controll_limit_sec * this.time_mag) - this.ops_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },

    //////////////////////////////////////////////////////////////////////////////// 時間の倍率

    time_mag() {
      if (this.room.bot_user_id) {
        return PRACTICE_MODE_MAGNIFICATION
      } else {
        return 1
      }
    },
  },
}
