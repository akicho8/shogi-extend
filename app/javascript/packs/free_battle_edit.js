// 棋譜入力用

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

const UPDATE_DELAY = 0.5 // プレビューするまでの遅延時間(秒)

window.FreeBattleEdit = Vue.extend({
  data() {
    return {
      record: this.$options.record_attributes,

      kifu_body: null,                         // 入力された棋譜
      auto_copy_to_kifu_body_disable_p: false, // true: 指し手をテキスト入力の方に反映しないようにする
      input_active_tab: 0,                     // 入力タブ切り替え
      output_kifs: this.$options.output_kifs,    // 変換後の棋譜
      output_active_tab: 0,                    // 変換後の棋譜の切り替え

      tab_names: [
        "操作入力",
        "テキスト入力",
      ],
    }
  },

  mounted() {
    this.kifu_body = this.record.kifu_body // 元の棋譜を復元
    if (!this.kifu_body) {
      this.kifu_body = localStorage.getItem("free_battle.kifu_body")
    }
    this.kifu_body_focus()
  },

  watch: {
    kifu_body() {
      this.preview_update_from_kifu_body()
      localStorage.setItem("free_battle.kifu_body", this.kifu_body)
    },
  },

  computed: {
    input_active_tab_name() {
      return this.tab_names[this.input_active_tab]
    },
  },

  methods: {
    preview_update_from_kifu_body: _.debounce(function() {
      this.play_mode_long_sfen_set(this.kifu_body)
    }, 1000 * UPDATE_DELAY),

    play_mode_long_sfen_set(play_mode_long_sfen) {
      const params = new URLSearchParams()
      params.append("kifu_body", play_mode_long_sfen)
      axios.post(this.$options.post_path, params).then((response) => {
        if (response.data.error_message) {
          Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
        }
        if (response.data.output_kifs) {
          this.output_kifs = response.data.output_kifs
          if (!this.auto_copy_to_kifu_body_disable_p) {
            if (this.input_active_tab_name !== "テキスト入力") {
              this.copy_to_kifu_body("kif")
            }
          }
        }
      }).catch((error) => {
        console.table([error.response])
        Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    copy_to_kifu_body(key) {
      if (this.output_kifs) {
        this.kifu_body = this.output_kifs[key]["value"]
      }
    },

    kifu_body_clear() {
      this.kifu_body = ""
      this.kifu_body_focus()
    },

    kifu_body_focus() {
      if (this.$refs.kifu_body) {
        this.$refs.kifu_body.focus()
      }
    },

    // 保持していた入力内容を破棄する
    // これは form の submit のタイミングで呼ばれる
    kifu_body_storage_clear() {
      localStorage.removeItem("free_battle.kifu_body")
    },

    kifu_copy(e) {
      if (this.output_kifs) {
        AppHelper.clipboard_copy({text: this.output_kifs[e.key]["value"]})
      }
    },
  },
})
