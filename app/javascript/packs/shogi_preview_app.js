// 棋譜入力用

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#shogi_preview_app',
    data() {
      return {
        kifu_body: "",
        // full_sfen: "position sfen startpos", // shogi-player に渡すための変数
        full_sfen: null, // shogi-player に渡すための変数
        update_delay: 1000 * 1, // 指定ms入力がなくなってからプレビューする
        kifu_active_tab: 0,
        kifu_infos: null,
      }
    },

    watch: {
      kifu_body(v) {
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
      }, this.update_delay),
    },
  })
})
