// 棋譜変換用

import _ from "lodash"
import * as AppUtils from "./app_utils.js"
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
        axios.post(shogi_preview_app_params.path, {
          kifu_body: this.kifu_body,
        }).then((response) => {
          this.kifu_body_sfen = response.data.sfen
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }, 1000 * 1),
    },
  })
})
