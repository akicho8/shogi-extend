export const app_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POSTする値
      body: "",           // 棋譜
      loop: "false",      // ループ
      delay_per_one: 1.0, // 表示秒数/1枚
      sleep: 0,           // 遅延(デバッグ用)
      raise_message: "",         // 例外メッセージ
      to_format: "gif",   // 変換先

      //////////////////////////////////////////////////////////////////////////////// その他
      bs_error: null, //  エラー情報
    }
  },
  watch: {
    body() {
      this.bs_error = null
      this.xconv_record = null
      this.done_record = null
    },
  },
  mounted() {
    let v = null
    v = this.$route.query.body
    if (this.present_p(v)) {
      this.body = v
    }
  },
  methods: {
    body_focus() {
      this.desktop_focus_to(this.$refs.XconvForm.$refs.body.$refs.textarea)
    },
    reset_handle() {
      this.sound_play("click")
      this.body = ""

      this.response_hash   = null
      // this.xconv_info    = null
      this.done_record = null
      this.xconv_record   = null

      // this.body_focus()
    },
    //- app_open(url) {
    //-   this.url_open(url, this.target_default)
    //- },

    sumit_handle() {
      this.done_record = null

      //- this.record_fetch(() => {
      //-   this.toast_ok(`${this.record.turn_max}手の棋譜として読み取りました`)
      //- })
      this.sound_play("click")
      if (this.bs_error) {
        this.error_show()
        return
      }

      if (this.blank_p(this.body) && false) {
        this.toast_warn("棋譜を入力してください")
        return
      }

      this.ga_click("アニメーションGIF変換●")
      const params = {
        // for XconvRecord
        body: this.body,

        // for XconvRecord#convert_params
        xconv_record_params: {
          sleep: this.sleep,
          raise_message: this.raise_message,

          board_binary_generator_params: {
            to_format: this.to_format,
            // for AnimationFormatter
            // animation_formatter_params: {
            loop: this.loop,
            delay_per_one: this.delay_per_one,
            // },
          },
        },
      }
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/xconv/record_create.json", params).then(e => {
        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.error_show()
        }
        if (e.response_hash) {
          this.response_hash = e.response_hash
          const xconv_record = e.response_hash.xconv_record
          if (xconv_record) {
            this.xconv_record = xconv_record
            this.toast_ok("変換を予約しました")
          }
        }
      }).finally(() => {
        loading.close()
      })
    },

    error_show() {
      this.bs_error_message_dialog(this.bs_error)
    },
  },
  computed: {
    body_field_type() {
      if (this.bs_error) {
        return "is-danger"
      }
      if (this.xconv_record) {
        return "is-success"
      }
    },
    form_show_p() {
      return true
      // return this.blank_p(this.xconv_record)
    },
    processing_p() {
      return this.xconv_record && !this.done_record
    },
  },
}
