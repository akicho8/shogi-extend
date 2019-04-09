// 棋譜入力用

// import Vue from "vue/dist/vue.esm"
import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

const UPDATE_DELAY = 0.5 // 指定秒入力がなくなってからプレビューする

window.ShogiPreviewApp = Vue.extend({
  data() {
    return {
      record: this.$options.record_attributes,
      kifu_body: null,        // 入力された棋譜
      // full_sfen: null,        // shogi-player に渡すための変数。"position sfen startpos" を入れておくと最初に平手を表示する
      auto_copy_to_kifu_body_disable_p: false,      //
      current_tab_index: 0,     // 入力タブ切り替え
      kifus_hash: this.$options.kifus_hash,       // 変換後の棋譜
      kifu_type_tab_index: 0,       // 変換後の棋譜の切り替え

      tab_list: [
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
    this.$refs.kifu_body.focus()           // HTMLの方で autofocus を指定しても Vue.js と組み合わせる外れるためこちらで指定
  },

  watch: {
    kifu_body() {
      this.preview_update_from_kifu_body()
      localStorage.setItem("free_battle.kifu_body", this.kifu_body)
    },
  },

  computed: {
    current_tab_name() {
      return this.tab_list[this.current_tab_index]
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
        if (response.data.kifus_hash) {
          this.kifus_hash = response.data.kifus_hash
          if (!this.auto_copy_to_kifu_body_disable_p) {
            if (this.current_tab_name !== "テキスト入力") {
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
      if (this.kifus_hash) {
        this.kifu_body = this.kifus_hash[key]["value"]
      }
    },

    kifu_body_clear() {
      this.kifu_body = ""
      this.$refs.kifu_body.focus()
    },

    // 保持していた入力内容を破棄する
    // これは form の submit のタイミングで呼ばれる
    kifu_body_storage_clear() {
      localStorage.removeItem("free_battle.kifu_body")
    },
  },
})
