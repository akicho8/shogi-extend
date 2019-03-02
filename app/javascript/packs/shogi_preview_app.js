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
      full_sfen: null,        // shogi-player に渡すための変数。"position sfen startpos" を入れておくと最初に平手を表示する

      // タブで切り替える部分(なくてもいい)
      kifu_infos: null,       //
      kifu_active_tab: 0,     //
    }
  },

  mounted() {
    this.kifu_body = this.record.kifu_body // 元の棋譜を復元
    this.$refs.kifu_body.focus()           // HTMLの方で autofocus を指定しても Vue.js と組み合わせる外れるためこちらで指定
  },

  watch: {
    kifu_body() {
      this.preview_update()
    },
  },

  methods: {
    preview_update: _.debounce(function() {
      const params = new URLSearchParams()
      params.append("kifu_body", this.kifu_body)
      axios.post(this.$options.post_path, params).then((response) => {
        if (response.data.error_message) {
          Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
        }
        if (response.data.sfen) {
          this.full_sfen = response.data.sfen
        }
        if (response.data.kifu_infos) {
          this.kifu_infos = response.data.kifu_infos
        }
      }).catch((error) => {
        console.table([error.response])
        Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    }, 1000 * UPDATE_DELAY),
  },
})
