// 棋譜変換用

import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#shogi_preview_app',
    data: function () {
      return {
        kifu_body: "",
        full_sfen: "position sfen startpos",
        update_delay: 1000 * 1, // 指定ms入力がなくなってからプレビューする
      }
    },

    watch: {
      kifu_body: function (v) {
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
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }, this.update_delay),
    },
  })
})
