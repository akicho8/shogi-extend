import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

import { CpuBrainInfo } from "./cpu_brain_info.js"
Object.defineProperty(Vue.prototype, "CpuBrainInfo", {value: CpuBrainInfo})

document.addEventListener('DOMContentLoaded', () => {
  const cpu_battles_app = new Vue({
    el: '#cpu_battles_app',
    data() {
      return {
        full_sfen: "position startpos",
        cpu_brain_key: js_cpu_battle.cpu_brain_key,
      }
    },

    computed: {
    },

    methods: {
      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)
        params.append("cpu_brain_key", this.cpu_brain_key)

        axios({
          method: "post",
          timeout: 1000 * 60 * 10,
          headers: {"X-TAISEN": true},
          url: js_cpu_battle.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data["error_message"]) {
            // Vue.prototype.$toast.open({message: response.data["error_message"], position: "is-bottom", type: "is-danger", duration: 1000 * 10})

            // // 元が成ってないとき
            // this.$dialog.confirm({
            //   message: 'err',
            //   confirmText: 'まった',
            //   cancelText: '不成',
            //   onConfirm: () => {
            //     // alert(response.data["before_sfen"])
            //     // alert(cpu_battles_app.full_sfen)
            //
            //     // this.full_sfen = response.data["before_sfen"]
            //   },
            //   // 最後に必ず呼ばれる
            //   onCancel: () => {
            //     // alert(response.data["before_sfen"])
            //     // this.full_sfen = response.data["before_sfen"]
            //     // // this.full_sfen = "position sfen startpos"
            //     this.start_turn = -2
            //   },
            // })

            Vue.prototype.$dialog.alert({
              title: "反則負け",
              message: response.data["error_message"],
              type: 'is-danger',
              hasIcon: true,
              icon: 'times-circle',
              iconPack: 'fa',
            })

            // Vue.prototype.$dialog.alert({
            //   message: response.data["normal_message"],
            // })

          }

          if (response.data["you_win_message"]) {
            // Vue.prototype.$toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

            Vue.prototype.$dialog.alert({
              title: "勝利",
              message: response.data["you_win_message"],
              type: 'is-primary',
              hasIcon: true,
              icon: 'crown',
              iconPack: 'mdi',
            })
          }

          if (response.data["you_lose_message"]) {
            // Vue.prototype.$toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

            Vue.prototype.$dialog.alert({
              title: "敗北",
              message: response.data["you_lose_message"],
              type: 'is-primary',
            })
          }

          if (response.data["sfen"]) {
            this.full_sfen = response.data["sfen"]
          }

        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },
    },
  })
})
