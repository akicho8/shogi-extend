export const app_yomiage = {
  data() {
    return {
      yomiage_cache: {},      // sfen をキーに読み上げ内容をキャッシュする
      yomiage_now: false,     // 読み上げ中なら true
      yomiage_index: 0,       //
      yomiage_speed: null,    // 読み上げ速度。localStorage から復帰設定。初期値 1.0 (localStorage)
      yomiage_interval: null, // 読み上げ間隔。localStorage から復帰設定。初期値 1.0 (localStorage)
      yomiage_answer: null,   // hidden:答えを隠す, visible:答え表示
      yomiage_list: null,     //
      yomiage_delay_timer: null,
    }
  },

  beforeDestroy() {
    this.yomiage_delay_stop()
  },

  methods: {
    async yomiage_play_handle() {
      this.sound_play_click()
      const sfen = this.sfen_flop(this.current_article.init_sfen)
      if (this.blank_p(this.yomiage_cache[sfen])) {
        await this.$axios.$post("/api/blindfold.json", {sfen: sfen, as: "yomiage_list"}).then(e => {
          this.bs_error_message_dialog(e)
          if (e.yomiage_list) {
            this.yomiage_cache[sfen] = e.yomiage_list
            // if (true) {
            //   this.yomiage_cache[sfen] = [
            //     { command: "talk",     message: "1", },
            //     { command: "interval", sleep: 2,     },
            //     { command: "talk",     message: "2", },
            //     { command: "interval", sleep: 2,     },
            //     { command: "talk",     message: "3", },
            //   ]
            // }
          }
        })
      }
      this.yomiage_list = this.yomiage_cache[sfen]
      if (this.present_p(this.yomiage_list)) {
        this.yomiage_start()
        // this.talk(yomiage_body, {rate: this.yomiage_speed, onend: () => this.yomiage_now = false})
      }
    },

    yomiage_start_init() {
      this.yomiage_index = 0
      this.yomiage_delay_stop()
    },

    yomiage_start() {
      this.sound_stop_all()
      this.yomiage_start_init()
      this.yomiage_now = true

      this.yomiage_chain()
    },

    yomiage_chain() {
      // チェインしかけても読み上げ中に手動停止すると yomiage_now は false なので停止する
      if (!this.yomiage_now) {
        return
      }

      // 終端なら終わる
      if (this.yomiage_end_p) {
        this.yomiage_now = false
        return
      }

      const e = this.yomiage_current
      if (e.command === "interval") {
        this.yomiage_delay_stop()
        const duration = e.sleep * this.yomiage_interval
        this.yomiage_delay_timer = this.delay_block(duration, () => this.yomiage_next())
      }
      if (e.command === "talk") {
        this.talk(e.message, {rate: this.yomiage_speed, onend: () => this.yomiage_next()})
      }
    },

    yomiage_next() {
      this.yomiage_index += 1
      this.yomiage_chain()
    },

    yomiage_stop_handle() {
      this.sound_stop_all()
      this.sound_play_click()
      this.yomiage_stop()
    },

    yomiage_stop() {
      this.yomiage_start_init()
      this.yomiage_now = false
    },

    yomiage_delay_stop() {
      if (this.yomiage_delay_timer) {
        this.delay_stop(this.yomiage_delay_timer)
        this.yomiage_delay_timer = null
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // 開始・正解不正解実行時
    yomiage_reset_on_play_start() {
      // 盤面を隠す
      this.yomiage_answer = "hidden"

      // 読み上げを停止する
      this.yomiage_stop()
    },

    // 右上のナビバーの盤面表示トグル
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

    yomiage_end_p()   { return this.blank_p(this.yomiage_list[this.yomiage_index]) },
    yomiage_current() { return this.yomiage_list[this.yomiage_index] },
  },
}
