import _ from "lodash"

const TEXT_INPUT_UPDATE_DELAY = 0.5 // プレビューするまでの遅延時間(秒)

const TAB_NAME_KEYS = [
  "棋譜入力",
  "操作入力",
]

export default {
  data() {
    return {
      // フォーム用
      record: this.$options.record_attributes,

      // 左側
      input_tab_index: 0,       // 入力タブ切り替え(棋譜で開始したければ1にする)
      input_text: null,         // 入力された棋譜
      board_sfen: null,         // 操作入力に渡す棋譜
      default_start_turn: null, // 最初の start_turn の指定
      run_mode: "play_mode",    // 操作入力の最初のモード

      // 右側
      output_active_tab: 0,                   // 変換後の棋譜の切り替え
      output_kifs: this.$options.output_kifs, // 変換後の棋譜
    }
  },

  created() {
    this.board_sfen = this.record.sfen_body

    // これは最初だけなので computed にしてはいけない
    this.default_start_turn = this.record.start_turn
    if (this.default_start_turn === null) {
      this.default_start_turn = 65536
    }
  },

  mounted() {
    // コピペ新規の場合
    if (this.record.kifu_body) {
      this.input_text = this.record.kifu_body
    }

    if (this.$options.free_battles_pro_mode) {
      if (!this.input_text && localStorage.getItem("free_battle.input_text")) {
        this.input_text = localStorage.getItem("free_battle.input_text")
      }
    }

    this.input_text_focus()
  },

  watch: {
    input_text(new_val, old_val) {
      if (old_val) {
        this.delayed_kifu_convert_by()
      } else {
        // 最初の設定の場合は即座にSFENに変換して盤に反映する
        this.kifu_convert_by(this.input_text)
      }
      if (this.$options.free_battles_pro_mode) {
        localStorage.setItem("free_battle.input_text", this.input_text)
      }
    },
  },

  computed: {
    input_tab_name() {
      return TAB_NAME_KEYS[this.input_tab_index]
    },

    text_mode_p() {
      return this.input_tab_name === "棋譜入力"
    },

    board_mode_p() {
      return this.input_tab_name === "操作入力"
    },
  },

  methods: {
    // 棋譜
    delayed_kifu_convert_by: _.debounce(function() { this.kifu_convert_by(this.input_text) }, 1000 * TEXT_INPUT_UPDATE_DELAY),

    // 操作入力
    play_mode_long_sfen_set(str) {
      this.kifu_convert_by(str)
    },

    // 操作入力の場合は即時反映
    kifu_convert_by(str) {
      const params = new URLSearchParams()
      params.set("input_text", str)

      this.$http.post(this.$options.post_path, params).then(response => {
        const e = response.data

        // BioshogiError の文言が入る
        if (e.bs_error) {
          this.$buefy.toast.open({message: e.bs_error.message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
        }

        if (e.output_kifs) {
          this.output_kifs = e.output_kifs
          this.turn_max_set(e)
          if (this.text_mode_p) {
            this.board_sfen = e.output_kifs.sfen.value
          }
          if (this.board_mode_p) {
            this.input_text_set("kif")
          }
        }
      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    // 手数関連を設定
    // フォームも更新する
    turn_max_set(e) {
      this.record.turn_max = e.turn_max

      // 設定されていないときだけ指定する
      if (this.record.start_turn === null) {
        this.record.start_turn = this.record.turn_max
      }

      // 棋譜編集したとき手数が範囲外なら調整する
      if (this.record.start_turn > this.record.turn_max) {
        this.record.start_turn = this.record.turn_max
      }
    },

    input_text_set(key) {
      if (this.output_kifs) {
        this.input_text = this.output_kifs[key].value
      }
    },

    input_text_clear() {
      this.input_text = ""
      this.input_text_focus()
    },

    input_text_focus() {
      if (this.$refs.input_text) {
        this.$refs.input_text.focus()
      }
    },

    // 保持していた入力内容を破棄する
    // これは form の submit のタイミングで呼ばれる
    input_text_storage_clear() {
      if (this.$options.free_battles_pro_mode) {
        localStorage.removeItem("free_battle.input_text")
      }
    },

    kifu_copy_to_clipboard(e) {
      if (this.output_kifs) {
        this.clipboard_copy({text: this.output_kifs[e.key].value})
      }
    },

    kifu_clone_and_new_tab_oepn_handle() {
      if (this.output_kifs) {
        const sfen = encodeURIComponent(this.output_kifs.sfen.value) // + をエスケープしないと空白になってしまうため
        const key = encodeURIComponent("free_battle[kifu_body]")
        const url = `${this.$options.new_path}?${key}=${sfen}`
        window.open(url, "_blank")
      }
    },
  },
}
