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
        kifu_body_sfen: "position sfen startpos",
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
        axios.post(shogi_preview_app_params.path, params).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger", duration: 1000 * 5})
          }
          if (response.data.sfen) {
            this.kifu_body_sfen = response.data.sfen
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }, 1000 * 1),            // 指定秒間放置されたらプレビューする
    },
  })
})
