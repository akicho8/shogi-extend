// import _ from "lodash"
// import axios from "axios"

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/lobby_channel.rb
  App.lobby = App.cable.subscriptions.create("LobbyChannel", {
    // Called when the subscription is ready for use on the server
    connected: function() {
      App.lobby_vm.puts("connected")
      // this.install()
      // this.appear()
      // this.perform("appear")
    },
    // Called when the WebSocket connection is closed
    disconnected: function() {
      App.lobby_vm.puts("disconnected")
      // this.uninstall()
    },
    // Called when the subscription is rejected by the server
    rejected: function() {
      App.lobby_vm.puts("rejected")
      // this.uninstall()
    },

    received: function(data) {
      // App.lobby_vm.chat_rooms = []
      // App.lobby_vm.chat_rooms = [data["chat_room"]]
      // App.lobby_vm.puts(data)
      if (data["chat_room"]) {
        App.lobby_vm.chat_rooms = _.concat([data["chat_room"]], App.lobby_vm.chat_rooms)
      }
      if (data["online_users"]) {
        App.lobby_vm.online_users = data["online_users"]
      }
    },

    // appear: function() {
    //   // Calls `LobbyChannel#appear(data)` on the server
    //   this.perform("appear", appearing_on: $("main").data("appearing-on"))
    // },
    // away: function() {
    //   // Calls `LobbyChannel#away` on the server
    //   this.perform("away")
    // },

    // buttonSelector = "[data-behavior~=appear_away]"
    // install: function() {
    //   $(document).on "turbolinks:load.lobby", =>
    //     this.appear()
    //   $(document).on "click.lobby", buttonSelector, =>
    //     this.away()
    //   false
    // $(buttonSelector).show()

    // uninstall: function() {
    //   $(document).off(".lobby")
    //   $(buttonSelector).hide()
    // },
  })

  App.lobby_vm = new Vue({
    el: "#lobby_app",
    data: function() {
      return {
        status_list: [],
        chat_rooms: [],
        online_users: [],                // 参加者
        columns: [
          { field: 'name', label: '部屋', },
        ],
        message_modal_p: false,
        message_to: null,
        message: "",
      }
    },
    methods: {
      puts(v) {
        this.status_list.push(v)
      },
      chat_user_self_p(chat_user) {
        return chat_user.id === lobby_app_params.current_chat_user.id
      },
      message_form_modal_open(message_to) {
        this.message_to = message_to
        this.message_modal_p = true
        this.$nextTick(() => this.$refs.message_input.focus())
      },
      message_enter() {
        if (this.message !== "") {
          // Vue.prototype.$toast.open({message: this.message, position: "is-bottom", type: "is-info", duration: 1000 * 2})
          App.web_notification.message_send_to({from: lobby_app_params.current_chat_user, to: this.message_to, message: this.message})
        }
        this.message = ""
      }
    },
    computed: {
      latest_status_list() {
        return _.takeRight(this.status_list, 10)
      },
    },
  })
})
