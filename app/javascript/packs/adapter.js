window.Transport = Vue.extend({
  data() {
    return {
      input_text: "68S",
      output_kifs: null,
      record: null,
      create_counter: 0,
    }
  },
  watch: {
    input_text() {
      this.create_counter = 0
    }
  },

  methods: {
    piyo_shogi_click_handle() {
      this.record_create(() => { this.other_window_open(this.record.piyo_shogi_app_url) })
    },

    kento_click_handle() {
      this.record_create(() => { this.other_window_open(this.record.kento_app_url) })
    },

    kifu_copy_click_handle() {
      this.record_create(() => { this.kifu_copy_exec(this.record.kifu_copy_params) })
    },

    // private

    record_create(callback) {
      if (this.create_counter >= 1) {
        if (this.record) {
          callback()
        }
        return
      }
      this.create_counter += 1

      const params = new URLSearchParams()
      params.set("input_any_kifu", this.input_text)
      params.set("edit_mode", "adapter")

      // TODO: あとでシンプルなのに変更する
      this.$http.post(this.$options.post_path, params).then(response => {
        const e = response.data
        if (e.errors_full_messages) {
          this.$buefy.toast.open({message: e.errors_full_messages.join("\n"), position: "is-bottom", type: "is-warning", duration: 1000 * 5})
        }
        if (e.output_kifs) {
          this.output_kifs = e.output_kifs
          // this.turn_max_set(e)
          // this.board_sfen = e.output_kifs.sfen.value
        }
        if (e.record) {
          this.record = e.record

          callback()

          // this.turn_max_set(e)
          // this.board_sfen = e.output_kifs.sfen.value
        }
      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },
  },
})
