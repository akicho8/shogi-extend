// 棋譜入力用

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

const TEXT_INPUT_UPDATE_DELAY = 0.5 // プレビューするまでの遅延時間(秒)

window.FreeBattleEdit = Vue.extend({
  data() {
    return {
      record: this.$options.record_attributes,

      input_text: null,                         // 入力された棋譜
      auto_copy_to_input_text_disable_p: false, // true: 指し手をテキスト入力の方に反映しないようにする
      input_active_tab: 0,                     // 入力タブ切り替え
      output_kifs: this.$options.output_kifs,    // 変換後の棋譜
      input_sfen: "",                         // 操作入力に渡す棋譜
      output_active_tab: 0,                    // 変換後の棋譜の切り替え

      tab_names: [
        "操作入力",
        "テキスト入力",
      ],
    }
  },

  mounted() {
    this.input_text = this.record.kifu_body // 元の棋譜を復元
    if (!this.input_text) {
      this.input_text = localStorage.getItem("free_battle.input_text")
    }
    this.input_text_focus()
  },

  watch: {
    input_text() {
      this.preview_update_from_input_text()
      localStorage.setItem("free_battle.input_text", this.input_text)
    },
  },

  computed: {
    input_active_tab_name() {
      return this.tab_names[this.input_active_tab]
    },
  },

  methods: {
    // テキスト入力の場合のみ入力が終わるまで少し待つ
    preview_update_from_input_text: _.debounce(function() {
      this.play_mode_long_sfen_set(this.input_text)
    }, 1000 * TEXT_INPUT_UPDATE_DELAY),

    // 操作入力の場合は即時反映
    play_mode_long_sfen_set(play_mode_long_sfen) {
      const params = new URLSearchParams()
      params.append("input_any_kifu", play_mode_long_sfen)
      axios.post(this.$options.post_path, params).then((response) => {
        if (response.data.error_message) {
          Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
        }
        if (response.data.output_kifs) {
          this.output_kifs = response.data.output_kifs
          if (this.input_active_tab_name !== "操作入力") {
            // 操作入力の場合は、入力内容が先祖返りするのを防ぐために、いまが「操作入力入力」でない場合のみ上書きするようにしている
            this.input_sfen = response.data.output_kifs["sfen"]["value"]
          }
          if (!this.auto_copy_to_input_text_disable_p) {
            // テキスト入力時は、入力内容が先祖返りするのを防ぐために、いまが「テキスト入力」でない場合のみ上書きするようにしている
            if (this.input_active_tab_name !== "テキスト入力") {
              this.copy_to_input_text("kif")
            }
          }
        }
      }).catch((error) => {
        console.table([error.response])
        Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    copy_to_input_text(key) {
      if (this.output_kifs) {
        this.input_text = this.output_kifs[key]["value"]
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
      localStorage.removeItem("free_battle.input_text")
    },

    kifu_copy(e) {
      if (this.output_kifs) {
        AppHelper.clipboard_copy({text: this.output_kifs[e.key]["value"]})
      }
    },
  },
})
