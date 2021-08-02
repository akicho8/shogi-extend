export const app_form = {
  data() {
    return {
      //////////////////////////////////////////////////////////////////////////////// POSTする値
      body: "",           // 棋譜
      loop: "false",      // ループ
      delay_per_one: 1.0, // 表示秒数/1枚
      sleep: 0,           // 遅延(デバッグ用)

      //////////////////////////////////////////////////////////////////////////////// その他
      bs_error: null, //  エラー情報
    }
  },
  watch: {
    body() {
      this.bs_error = null
      this.henkan_record = null
      this.success_record = null
    },
  },
  mounted() {
    //- this.ga_click("アニメーションGIF変換")

    let v = null
    v = this.$route.query.body
    if (this.present_p(v)) {
      this.body = v
      //- this.change_counter += 1

      //- if (AUTO_APP_TO) {
      //-   let v = this.$route.query.app_to
      //-   if (v) {
      //-     v = _.snakeCase(v)
      //-     const app_to = this[`${v}_open_handle`] // piyo_shogi_open_handle, kento_open_handle, share_board_open_handle
      //-     app_to()
      //-   } else {
      //-     this.sumit_handle()
      //-   }
      //- }
    }

    // this.body_focus()
  },
  methods: {
    body_focus() {
      this.desktop_focus_to(this.$refs.GifConvForm.$refs.body.$refs.textarea)
    },
    reset_handle() {
      this.sound_play("click")
      this.body = ""

      this.response_hash   = null
      // this.teiki_haisin    = null
      this.success_record = null
      this.henkan_record   = null

      // this.body_focus()
    },
    //- app_open(url) {
    //-   this.url_open(url, this.target_default)
    //- },

    sumit_handle() {
      this.success_record = null

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
        body:          this.body,
        sleep:         this.sleep,
        loop:          this.loop,
        delay_per_one: this.delay_per_one,
      }
      const loading = this.$buefy.loading.open()
      this.$axios.$post("/api/gif_conv/record_create.json", params).then(e => {
        if (e.bs_error) {
          this.bs_error = e.bs_error
          this.error_show()
        }
        if (e.response_hash) {
          this.response_hash = e.response_hash
          const henkan_record = e.response_hash.henkan_record
          if (henkan_record) {
            this.henkan_record = henkan_record
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
      if (this.henkan_record) {
        return "is-success"
      }
    },
    form_show_p() {
      return true
      // return this.blank_p(this.henkan_record)
    },
    processing_p() {
      return this.henkan_record && !this.success_record
    },
  },
}
