document.addEventListener('DOMContentLoaded', () => {
  App.system_notification = App.cable.subscriptions.create({
    channel: "SystemNotificationChannel",
  }, {
    connected() {
      App.system_notification_vm.puts("connected")
    },
    disconnected() {
      App.system_notification_vm.puts("disconnected")
    },
    rejected: function() {
      App.system_notification_vm.puts("rejected")
    },
    received(data) {
      App.system_notification_vm.puts("received")

      if (data["message"]) {
        const message = data["message"]
        const from = data["from"]
        const str = `${from.name}: ${message}`
        Vue.prototype.$toast.open({message: str, position: "is-top", type: "is-success", duration: 1000 * 3})
      }

      if (data["active_user_count"]) {
        App.header_vm.active_user_count = data["active_user_count"]
      }
    },

    // 自由に定義してよいメソッド
    message_send_all(data) {
      this.perform("message_send_all", data)
    },
  })

  App.system_notification_vm = new Vue({
    el: "#system_notification_app",
    data: function() {
      return {
        system_logs: [],
      }
    },
    methods: {
      puts(v) {
        this.system_logs.push(v)
      },
    },
    computed: {
      latest_system_logs() {
        return _.takeRight(this.system_logs, 10)
      },
    },
  })

  App.header_vm = new Vue({
    el: "#header_app",
    data() {
      return {
        active_user_count: 0,
      }
    },
  })
})
