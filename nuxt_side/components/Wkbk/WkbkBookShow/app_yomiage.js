export const app_yomiage = {
  data() {
    return {
      yomiage_cache: {},
      yomiage_now: false,
      yomiage_speed: null, // localStorage から復帰設定
      yomiage_answer: "hidden",
    }
  },
  methods: {
    async yomiage_play_handle() {
      this.sound_play_click()
      const sfen = this.sfen_flop(this.current_article.init_sfen)
      if (this.blank_p(this.yomiage_cache[sfen])) {
        await this.$axios.$post("/api/blindfold.json", {sfen: sfen}).then(e => {
          this.bs_error_message_dialog(e)
          if (e.yomiage_body) {
            this.yomiage_cache[sfen] = e.yomiage_body
          }
        })
      }
      const yomiage_body = this.yomiage_cache[sfen]
      if (this.present_p(yomiage_body)) {
        this.sound_stop_all()
        this.yomiage_now = true
        this.talk(yomiage_body, {rate: this.yomiage_speed, onend: () => this.yomiage_now = false})
      }
    },

    yomiage_stop_handle() {
      this.sound_stop_all()
      this.yomiage_now = false
      this.sound_play_click()
    },

    yomiage_answer_toggle_handle() {
      this.sound_play_click()
      if (this.yomiage_answer === "visible") {
        this.yomiage_answer = "hidden"
      } else if (this.yomiage_answer === "hidden") {
        this.yomiage_answer = "visible"
      }
    },
  },
  computed: {
    yomiage_slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
      }
    },
  },
}
