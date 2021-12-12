export const app_play_break = {
  data() {
    return {
    }
  },
  methods: {
    time_over_p_check() {
      if (this.time_over_p) {
        this.stop_handle()
        this.toast_ok("時間切れ")
      }
    },

    too_many_mistake_check() {
      if (this.too_many_mistake_p) {
        this.stop_handle()
        this.too_many_mistake_alert()
      }
    },

    too_many_mistake_alert() {
      this.toast_ok("ミスが多すぎるので終了")
    },
  },

  computed: {
    // 時間切れか？
    time_over_p() {
      return this.spent_sec >= this.rule_info.time_limit
    },

    // ミスの許容を超えたか？
    too_many_mistake_p() {
      return this.x_count >= this.rule_info.play_break_miss_count
    },
  },
}
