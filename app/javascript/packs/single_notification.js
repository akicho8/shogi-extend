// import _ from "lodash"
// import axios from "axios"

document.addEventListener('DOMContentLoaded', () => {
  App.single_notification = App.cable.subscriptions.create({
    channel: "SingleNotificationChannel",
  }, {
    connected() {
    },

    disconnected() {

    },
    received(data) {
      if (data["battle_request"]) {
        const e = data["battle_request"]
        // const message = data["message"]
        // const from = data["from"]
        // const to = data["to"]
        // str = `${from.name}: ${message}`
        // Vue.prototype.$toast.open({message: str, position: "is-bottom", type: "is-info", duration: 1000 * 2})

        if (this.dialog_now) {
          this.perform("battle_match_ng", data)
        }

        let message = ``
        message += `時間: ${LifetimeInfo.fetch(e.from.lifetime_key).name}<br/>`
        if (e.from.ps_preset_key === "平手" && e.from.po_preset_key === "平手") {
          message += `手合割: 平手<br/>`
        } else {
          message += `手合割: 駒落ち<br/>`
          message += `※あなた: ${e.from.po_preset_key}<br/>`
          message += `※相手: ${e.from.ps_preset_key}<br/>`
        }

        this.dialog_now = true
        this.confirmed = false
        Vue.prototype.$dialog.confirm({
          title: `${e.from.name}さんからの挑戦状`,
          message: message,
          confirmText: "受ける",
          cancelText: 'ごめん',
          focusOn: "cancel",
          onConfirm: () => {
            this.confirmed = true
            // // this.$toast.open('User confirmed')
          },
          onCancel: (e) => {
            this.dialog_now = false
            if (this.confirmed) {
              this.perform("battle_match_ok", data)
            } else {
              this.perform("battle_match_ng", data)
            }
            // Vue.prototype.$toast.open(`${this.foo}`)
            // Vue.prototype.$toast.open("に")
            // console.log("onCancel")
          },
        })
      }

      if (data["message"]) {
        const message = data["message"]
        const from = data["from"]
        const to = data["to"]
        str = `${from.name}: ${message}`
        Vue.prototype.$toast.open({message: str, position: "is-bottom", type: "is-info", duration: 1000 * 2})
      }

      // マッチングが成立した
      if (data["matching_ok"]) {
        const chat_room = data["chat_room"]
        location.href = chat_room["show_path"]
        if (chat_room.auto_matched_at) {
          Vue.prototype.$toast.open({message: "マッチングが成立しました", position: "is-bottom", type: "is-info", duration: 1000 * 2})
        }
      }

    },

    message_send_to(data) {
      this.perform("message_send_to", data)
    },

    battle_request_to(data) {
      this.perform("battle_request_to", data)
    },
  })

  App.single_notification_vm = new Vue({
    el: "#single_notification_app",
    data() {
      return {
      }
    },
    watch: {
    },
    methods: {
    },
    computed: {
    },
  })
})
