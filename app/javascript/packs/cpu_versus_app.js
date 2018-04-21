import _ from "lodash"
import * as AppUtils from "./app_utils.js"
import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#cpu_versus_app',
    data: function() {
      return {
        kifu_body_sfen: "position startpos",

        cpu_tuyosa_key: "hutuu",
        cpu_tuyosa_infos: {
          yowai:  { name: "弱い", time_limit:  1 },
          hutuu:  { name: "普通", time_limit:  3 },
          tuyoi:  { name: "強い", time_limit:  5 },
          // saikyo: { name: "もっと強いけどめっちゃ時間かかる", time_limit: 30 },
        },
      }
    },
    computed: {
      tuyosa_info() {
        return this.cpu_tuyosa_infos[this.cpu_tuyosa_key]
      },
    },
    methods: {
      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)
        params.append("time_limit", this.tuyosa_info.time_limit)

        axios({
          method: "post",
          timeout: 1000 * 60 * 10,
          headers: {"X-TAISEN": true},
          url: cpu_versus_app_params.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger"})
          }
          if (response.data.toryo_message) {
            Vue.prototype.$toast.open({message: response.data.toryo_message, position: "is-bottom", type: "is-info", duration: 1000 * 60 * 60})
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
