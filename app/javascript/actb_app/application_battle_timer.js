export const application_battle_timer = {
  data() {
    return {
      main_interval_id: null,
      main_interval_count: null,
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
      if (this.battle.rule.key === "marathon_rule") {
        if (this.sub_mode === "operation_mode") {
          this.main_interval_count += 1
          if (this.main_rest_seconds === 0) {
            this.kotae_sentaku('timeout')
          }
        }
      }
      if (this.battle.rule.key === "hybrid_rule") {
        if (this.sub_mode === "operation_mode") {
          this.main_interval_count += 1
          if (this.main_rest_seconds === 0) {
            if (this.leader_p) {
              this.kotae_sentaku('timeout') // [ONCE]
            }
          }
        }
      }
      if (this.battle.rule.key === "singleton_rule") {
        if (this.sub_mode === "operation_mode") {
          if (this.x_mode === "x1_thinking") {
            this.main_interval_count += 1
            if (this.main_rest_seconds === 0) {
              if (this.leader_p) {
                this.kotae_sentaku('timeout') // [ONCE]
              }
            }
          }
        }
      }
    },

    //////////////////////////////////////////////////////////////////////////////// シングルトン専用

    s_interval_start() {
      this.s_interval_stop()
      this.s_interval_count = 0
      this.s_interval_id = setInterval(this.s_interval_processing, 1000)
    },

    s_interval_stop() {
      if (this.s_interval_id) {
        clearInterval(this.s_interval_id)
        this.s_interval_id = null
      }
    },

    s_interval_restart() {
      this.s_interval_stop()
      this.s_interval_start()
    },

    s_interval_processing() {
      if (this.sub_mode === "operation_mode") {
        this.s_interval_count += 1
        if (this.s_rest_seconds === 0) {
          this.x2_play_timeout_handle()
        }
      }
    },
    ////////////////////////////////////////////////////////////////////////////////
  },

  computed: {
    ////////////////////////////////////////////////////////////////////////////////
    main_time_str() {
      return dayjs().startOf("year").set("seconds", this.main_rest_seconds).format("m:ss")
    },
    main_rest_seconds() {
      let v = this.main_time_limit_sec - this.main_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },
    main_time_limit_sec() {
      let v = null

      v = this.app.config.time_limit_sec
      if (v != null) {
        return v
      }

      v = this.battle.rule.time_limit_sec
      if (v != null) {
        return v
      }

      return this.current_question.time_limit_sec
    },

    ////////////////////////////////////////////////////////////////////////////////

    s_rest_seconds() {
      let v = this.config.s_time_limit_sec - this.s_interval_count
      if (v < 0) {
        v = 0
      }
      return v
    },
  },
}
