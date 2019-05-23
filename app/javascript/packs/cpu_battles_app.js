import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"

import CpuBrainInfo from "./cpu_brain_info.js"

window.CpuBattlesApp = Vue.extend({
  data() {
    return {
      CpuBrainInfo,
      sp_params: this.$options.sp_params,
      full_sfen: "position startpos",
      cpu_brain_key: this.$options.cpu_brain_key,
      current_user: js_global.current_user, // 名前を読み上げるため
    }
  },

  created() {
    setTimeout(() => AppHelper.talk(`よろしくお願いします。${this.current_call_name}のてばんです`), 1000 * 1)
  },

  computed: {
    cpu_brain_info() {
      return CpuBrainInfo.fetch(this.cpu_brain_key)
    },

    // 対戦者の名前
    current_call_name() {
      let str = null
      if (!str) {
        if (this.current_user) {
          str = `${this.current_user.name}さん`
        }
      }
      if (!str) {
        str = "あなた"
      }
      return str
    },
  },

  watch: {
    cpu_brain_key() {
      AppHelper.talk(`${this.cpu_brain_info.name}に変更しました`)
    },
  },

  methods: {
    play_mode_long_sfen_set(v) {
      const params = new URLSearchParams()
      params.append("kifu_body", v)
      params.append("cpu_brain_key", this.cpu_brain_key)

      axios({
        method: "post",
        timeout: 1000 * 60 * 10,
        headers: {"X-TAISEN": true}, // 入れてみただけ
        url: this.$options.player_mode_moved_path,
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
          AppHelper.talk("反則負けです")

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
          AppHelper.talk("勝ちました")
        }

        if (response.data["you_lose_message"]) {
          // Vue.prototype.$toast.open({message: response.data["normal_message"], position: "is-bottom", type: "is-info", duration: 1000 * 10})

          Vue.prototype.$dialog.alert({
            title: "敗北",
            message: response.data["you_lose_message"],
            type: 'is-primary',
          })
          AppHelper.talk("負けました")
        }

        // CPUの指し手を読み上げる
        if (response.data["yomiage"]) {
          AppHelper.talk(response.data["yomiage"])
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
