// 棋譜入力用

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

const UPDATE_DELAY = 1000 * 0.5 // 指定ms入力がなくなってからプレビューする

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: "#shogi_preview_app",
    data() {
      return {
        kifu_body: "",          // 入力された棋譜
        full_sfen: null,        // shogi-player に渡すための変数。"position sfen startpos" を入れておくと最初に平手を表示する
        kifu_infos: null,       //
        kifu_active_tab: 0,     //
      }
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
        axios.post(js_preview_params.path, params).then((response) => {
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
      }, UPDATE_DELAY),
    },
  })
})
