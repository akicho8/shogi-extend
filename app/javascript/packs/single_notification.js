import { LifetimeInfo } from "./lifetime_info"

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
          this.message_send_to({from: e["to"], to: e["from"], message: `(他の人からの挑戦状を見ている状態なので少ししてから送ってください)`})
          return
        }

        const hirate_p = (e.from.ps_preset_key === "平手" && e.from.po_preset_key === "平手")
        const message_template = `
<nav class="level">
  <div class="level-item has-text-centered">
    <div>
      <p class="heading">持ち時間</p>
      <p class="title is-size-4">${LifetimeInfo.fetch(e.from.lifetime_key).name}</p>
    </div>
  </div>
  <% if (!hirate_p) { %>
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">手合割(あなた)</p>
        <p class="title is-size-4">${e.from.po_preset_key}</p>
      </div>
    </div>
    <div class="level-item has-text-centered">
      <div>
        <p class="heading">手合割(相手)</p>
        <p class="title is-size-4">${e.from.ps_preset_key}</p>
      </div>
    </div>
  <% } %>
</nav>
`
        const message = _.template(message_template)({hirate_p: hirate_p})

        this.dialog_now = true
        Vue.prototype.$dialog.confirm({
          // size: "is-large",
          title: `${e.from.name}さんからの挑戦状`,
          message: message,
          confirmText: "受ける",
          cancelText: 'ごめん',
          focusOn: "cancel",
          onConfirm: () => {
            this.dialog_now = false
            this.perform("battle_match_ok", data)
          },
          onCancel: () => {
            this.dialog_now = false
            this.perform("battle_match_ng", data)
          },
        })
      }

      if (data["message"]) {
        const message = data["message"]
        const from = data["from"]
        const to = data["to"]
        const str = `${from.name}: ${message}`
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
