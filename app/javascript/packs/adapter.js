window.Adapter = Vue.extend({
  data() {
    return {
      input_text: null,
      output_kifs: null,
      record: null,
      change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
      fetched_counter: 0,
      bs_error: null,
      error_counter: 0,
      other_display: false,
      board_show: false,
      _loading: null,

      modal_p: false,
    }
  },

  mounted() {
    this.desktop_only_focus(this.$refs.input_text)

    // 変更した状態にする
    this.input_text = ""

    if (this.development_p) {
      this.input_text = ""
    }

    // // easy_dialog(params) {
    // //   params = {
    // //     ...params,
    // //     // 連打でスキップしてしまうことがあるため指定しない
    // //     // canCancel: ["outside", "escape"],
    // //     trapFocus: true,
    // //   }
    // this.$buefy.dialog.alert({
    //   title: "反則負け",
    //   message: "<hr>あああ<hr>",
    //   type: "is-danger",
    //   hasIcon: true,
    //   icon: "times-circle",
    //   iconPack: "fa",
    //   trapFocus: true,
    // })
  },

  watch: {
    input_text() {
      this.change_counter += 1
      this.record = null
      this.bs_error = null
    }
  },

  computed: {
    field_type() {
      if (this.change_counter === 0) {
        if (this.bs_error) {
          return "is-danger"
        }
        if (this.record) {
          return "is-success"
        }
      }
    },
    field_message() {
      if (this.change_counter === 0) {
        if (this.bs_error) {
          return `${this.bs_error.message_prefix}${this.bs_error.message}`
        }
      }
    },
  },

  methods: {
    piyo_shogi_click_handle() {
      this.record_create(() => { this.other_window_open(this.record.piyo_shogi_app_url) })
    },

    kento_click_handle() {
      this.record_create(() => { this.other_window_open(this.record.kento_app_url) })
    },

    kifu_copy_click_handle(kifu_type) {
      this.record_create(() => {
        this.clipboard_copy({text: this.output_kifs[kifu_type].value, success_message: "棋譜をクリップボードにコピーしました"})
      })
    },

    validate_click_handle() {
      this.record_create(() => { this.$buefy.toast.open({message: "OK", position: "is-bottom", type: "is-success"}) })
    },

    error_click_handle() {
      this.input_text = "68銀 12玉"
      this.validate_click_handle()
    },

    // 「その他」
    other_click_handle() {
      this.other_display = true
    },

    // 「棋譜印刷」
    print_out_click_handle() {
      this.record_create(() => { this.other_window_open(this.record.formal_sheet_path) })
    },

    // 「KIFダウンロード」
    kif_download_click_handle(kifu_type) {
      this.record_create(() => { this.other_window_open(`${this.record.show_path}.${kifu_type}`) })
    },

    // 「表示」
    kif_show_click_handle(kifu_type) {
      this.record_create(() => { this.other_window_open(`${this.record.show_path}.${kifu_type}?plain=true`) })
    },

    // 「盤面」
    board_show_click_handle() {
      this.record_create(() => {
        this.modal_p = true
      })
    },

    // private

    record_create(callback) {
      if (this.change_counter === 0) {
        if (this.record) {
          callback()
        }
      }
      if (this.change_counter >= 1) {
        this.record_force_create(callback)
      }
    },

    loading_off() {
      if (this.$data._loading) {
        this.$data._loading.close()
        this.$data._loading = null
      }
    },

    record_force_create(callback) {
      if (this.$data._loading) {
        return
      }

      this.$data._loading = this.$buefy.loading.open()

      const params = new URLSearchParams()
      params.set("input_any_kifu", this.input_text)
      params.set("edit_mode", "adapter")

      this.$http.post(this.$options.post_path, params).then(response => {
        this.loading_off()
        const e = response.data

        // BioshogiError の文言が入る
        if (e.bs_error) {
          this.error_counter += 1
          this.bs_error = e.bs_error
          this.talk(this.bs_error.message, {rate: 1.0})

          if (this.development_p) {
            this.$buefy.toast.open({message: e.bs_error.message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
          }

          if (this.development_p && false) {
            this.$buefy.dialog.alert({
              title: "ERROR",
              message: `<div>${e.bs_error.message}</div><div class="error_message_pre is-size-7">${e.bs_error.board}</div>`,
              canCancel: ["outside", "escape"],
              type: "is-danger",
              hasIcon: true,
              icon: "times-circle",
              iconPack: "fa",
              trapFocus: true,
            })
          }
        } else {
          this.bs_error = null
        }

        if (e.output_kifs) {
          this.output_kifs = e.output_kifs
          // this.turn_max_set(e)
          // this.board_sfen = e.output_kifs.sfen.value
        } else {
          this.output_kifs = null
        }

        this.change_counter = 0

        if (e.record) {
          this.record = e.record

          callback()

          // this.turn_max_set(e)
          // this.board_sfen = e.output_kifs.sfen.value
        } else {
          this.record = null
        }
      }).catch(error => {
        this.loading_off()

        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

  },
})
