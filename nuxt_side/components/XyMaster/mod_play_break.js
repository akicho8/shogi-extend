export const mod_play_break = {
  methods: {
    time_over_check() {
      if (this.rule_info.time_over_p(this.spent_sec)) {
        this.stop_handle()
        this.time_over_alert()
      }
    },

    time_over_alert() {
      this.toast_primary("時間切れ")
      this.app_log({subject: "符号の鬼", body: "時間切れ"})
    },

    too_many_miss_check() {
      if (this.rule_info.too_many_miss_p(this.x_count)) {
        this.stop_handle()
        this.too_many_miss_alert()
      }
    },

    too_many_miss_alert() {
      this.toast_primary("ミスが多すぎるので終了")
      this.app_log({subject: "符号の鬼", body: "ミスが多すぎるので終了"})
    },
  },
}
