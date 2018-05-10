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

        Vue.prototype.$dialog.confirm({
          title: `${e.from.name}さんから挑戦されています`,
          message: `
時間:${e.from.lifetime_key}<br/>
あなた:${e.from.po_preset_key}<br/>
相手:${e.from.ps_preset_key}<br/>
`,
          confirmText: '戦う',
          cancelText: '断わる',
          onConfirm: () => {
            // this.$toast.open('User confirmed')
            this.perform("battle_match_ok", data)
          },
          onCancel: () => {
            console.log("onCancel")
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
        Vue.prototype.$toast.open({message: "マッチングが成立しました", position: "is-bottom", type: "is-info", duration: 1000 * 2})
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
