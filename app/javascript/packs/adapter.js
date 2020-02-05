import ls_support from "ls_support.js"

window.Adapter = Vue.extend({
  mixins: [ls_support],

  data() {
    return {
      // フォーム関連
      input_text: null,    // 入力した棋譜
      option_show_p: null, // オプション有効か？ (永続化)
      board_show_p: false, // 「盤面」を押した？

      // データ
      output_kifs: null, // 変換した棋譜
      record: null,      // FreeBattle のインスタンスの属性たち + いろいろんな情報
      bs_error: null,    // BioshogiError の情報 (Hash)

      // その他
      change_counter: 0, // 1:更新した状態からはじめる 0:更新してない状態(変更したいとボタンが反応しない状態)
      _loading: null,    // ajax中なら $buefy.loading.open() のインスタンスが入ってる
    }
  },

  mounted() {
    // デスクトップのときだけ棋譜のテキストエリアにフォーカス
    this.desktop_only_focus(this.$refs.input_text)

    // 変更した状態にしておく
    this.input_text = ""
  },

  watch: {
    input_text() {
      this.change_counter += 1
      this.record = null
      this.bs_error = null
    },
  },

  computed: {
    //////////////////////////////////////////////////////////////////////////////// view

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
          return _.compact([this.bs_error.message, this.bs_error.message_prefix]).join(" ")
        }
      }
    },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_key() {
      return "adapter"
    },

    ls_data() {
      return {
        option_show_p: false,
      }
    },
  },

  methods: {
    piyo_shogi_open_handle() {
      this.record_fetch(() => this.other_window_open(this.record.piyo_shogi_app_url))
    },

    kento_open_handle() {
      this.record_fetch(() => this.other_window_open(this.record.kento_app_url))
    },

    kifu_copy_handle(kifu_type) {
      this.record_fetch(() => this.clipboard_copy({text: this.output_kifs[kifu_type].value, success_message: "棋譜をクリップボードにコピーしました"}))
    },

    validate_handle() {
      this.record_fetch(() => this.$buefy.toast.open({message: "OK", position: "is-bottom", type: "is-success"}))
    },

    ng_test_handle() {
      this.input_text = "68銀 12玉"
      this.$nextTick(() => this.validate_handle())
    },

    ok_test_handle() {
      this.input_text = "68銀、三4歩・☗七九角、8四歩五六歩△85歩78金"
      this.$nextTick(() => this.validate_handle())
    },

    // 「棋譜印刷」
    kifu_paper_handle() {
      this.record_fetch(() => this.other_window_open(this.record.formal_sheet_path))
    },

    // 「KIFダウンロード」
    kifu_dl_handle(kifu_type) {
      this.record_fetch(() => this.other_window_open(`${this.record.show_path}.${kifu_type}?attachment=true`))
    },

    // 「表示」
    kifu_show_handle(kifu_type) {
      this.record_fetch(() => this.other_window_open(`${this.record.show_path}.${kifu_type}`))
    },

    // 画像 表示
    png_show_handle(disposition) {
      this.record_fetch(() => this.other_window_open(`${this.record.show_path}.png?width=840&turn=${this.record.turn_max}`))
    },

    // 画像 DL
    png_dl_handle() {
      this.record_fetch(() => this.other_window_open(`${this.record.show_path}.png?width=840&turn=${this.record.turn_max}&disposition=attachment`))
    },

    // 「盤面」
    board_show_handle() {
      this.record_fetch(() => this.board_show_p = true)
    },

    // private

    record_fetch(callback) {
      if (this.change_counter === 0) {
        if (this.record) {
          callback()
        }
      }
      if (this.change_counter >= 1) {
        this.record_create(callback)
      }
    },

    loading_close() {
      if (this.$data._loading) {
        this.$data._loading.close()
        this.$data._loading = null
      }
    },

    record_create(callback) {
      if (this.$data._loading) {
        return
      }

      this.$data._loading = this.$buefy.loading.open()

      const params = new URLSearchParams()
      params.set("input_text", this.input_text)
      params.set("edit_mode", "adapter")

      this.$http.post(this.$options.post_path, params).then(response => {
        this.loading_close()
        this.change_counter = 0

        this.bs_error = null
        this.output_kifs = null
        this.output_kifs = null

        const e = response.data

        if (e.redirect_to) {
          if (true) {
            // リダイレクトしたあとブラウザバックで戻ると前の入力が残っている状態になる
            // このとき内部の変数 input_text は空！なので、KENTOを押すと空の棋譜を作って飛んでします
            // それを防ぐためにリダイレクト前に消している
            this.input_text = ""
          }
          this.self_window_open(e.redirect_to)
        }

        if (e.bs_error) {
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
        }

        if (e.output_kifs) {
          this.output_kifs = e.output_kifs
        }

        if (e.record) {
          this.record = e.record
          callback()
        }

      }).catch(error => {
        this.loading_close()
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
