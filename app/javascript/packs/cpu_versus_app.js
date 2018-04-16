import _ from "lodash"
import * as AppUtils from "./app_utils.js"
import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#cpu_versus_app',
    data: function() {
      return {
        kifu_body_sfen: "position startpos",
      }
    },
    methods: {
      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)

        axios({
          method: "post",
          timeout: 1000 * 10,
          headers: {"X-TAISEN": true},
          url: cpu_versus_app_params.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger"})
          }
          if (response.data.sfen) {
            this.kifu_body_sfen = response.data.sfen
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },
    },
  })
})
