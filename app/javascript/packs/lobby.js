// import Vue from 'vue/dist/vue.esm'
// import messenger from '../messenger.vue'

import _ from "lodash"

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/lobby_channel.rb
  App.lobby = App.cable.subscriptions.create("LobbyChannel", {
    connected: function() {
      // App.lobby_vm.puts("connected")
      // this.install()
      // this.appear()
      // this.perform("appear")
    },
    // Called when the WebSocket connection is closed
    disconnected: function() {
      // App.lobby_vm.puts("disconnected")
      // this.uninstall()
    },
    // Called when the subscription is rejected by the server
    rejected: function() {
      // App.lobby_vm.puts("rejected")
      // this.uninstall()
    },

    received: function(data) {
      // App.lobby_vm.chat_rooms = []
      // App.lobby_vm.chat_rooms = [data["chat_room"]]
      // App.lobby_vm.puts(data)
      if (data["chat_room_created"]) {
        App.lobby_vm.chat_rooms = _.concat([data["chat_room_created"]], App.lobby_vm.chat_rooms)
      }
      if (data["chat_rooms"]) {
        App.lobby_vm.chat_rooms = data["chat_rooms"]
      }
      if (data["online_users"]) {
        App.lobby_vm.online_users = data["online_users"]
      }
    },

    matching_start(data) {
      this.perform("matching_start", data)
    },
    matching_cancel(data) {
      this.perform("matching_cancel", data)
    },

    // appear: function() {
    //   // Calls `LobbyChannel#appear(data)` on the server
    //   this.perform("appear", appearing_at: $("main").data("appearing-on"))
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
    // components: { "messenger": messenger },
    data: function() {
      return {
        // status_list: [],
        chat_rooms: [],
        online_users: [],                // 参加者
        columns: [
          { field: 'name', label: '部屋', },
        ],
        matching_start_p: !_.isNil(js_global_params.current_chat_user.matching_at),
      }
    },
    methods: {
      // puts(v) {
      //   this.status_list.push(v)
      // },
      chat_user_self_p(chat_user) {
        return chat_user.id === js_global_params.current_chat_user.id
      },
      matching_click() {
        if (this.matching_start_p) {
          this.matching_start_p = false
          App.lobby.matching_cancel()
        } else {
          this.matching_start_p = true
          App.lobby.matching_start()
        }
      },
    },
    computed: {
      // latest_status_list() {
      //   return _.takeRight(this.status_list, 10)
      // },
      matching_class() {
        if (this.matching_start_p) {
          return ["is-danger"]
        } else {
          return ["is-primary"]
        }
      },

      matching_label() {
        if (this.matching_start_p) {
          return "マッチング中"
        } else {
          return "自動マッチング開始"
        }
      },

    },
  })
})
