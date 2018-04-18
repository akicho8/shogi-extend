// import _ from "lodash"
// import axios from "axios"

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

document.addEventListener('DOMContentLoaded', () => {
  // ~/src/shogi_web/app/channels/appearance_channel.rb
  App.appearance = App.cable.subscriptions.create("AppearanceChannel", {
    // Called when the subscription is ready for use on the server
    connected: function() {
      App.appearance_vm.puts("connected")
      // this.install()
      // this.appear()
      // this.perform("appear")
    },
    // Called when the WebSocket connection is closed
    disconnected: function() {
      App.appearance_vm.puts("disconnected")
      // this.uninstall()
    },
    // Called when the subscription is rejected by the server
    rejected: function() {
      App.appearance_vm.puts("rejected")
      // this.uninstall()
    },

    received: function(data) {
      // App.appearance_vm.chat_rooms = []
      // App.appearance_vm.chat_rooms = [data["chat_room"]]
      // App.appearance_vm.puts(data)
      if (data["chat_room"]) {
        App.appearance_vm.chat_rooms = _.concat([data["chat_room"]], App.appearance_vm.chat_rooms)
      }
    },

    // appear: function() {
    //   // Calls `AppearanceChannel#appear(data)` on the server
    //   this.perform("appear", appearing_on: $("main").data("appearing-on"))
    // },
    // away: function() {
    //   // Calls `AppearanceChannel#away` on the server
    //   this.perform("away")
    // },

    // buttonSelector = "[data-behavior~=appear_away]"
    // install: function() {
    //   $(document).on "turbolinks:load.appearance", =>
    //     this.appear()
    //   $(document).on "click.appearance", buttonSelector, =>
    //     this.away()
    //   false
    // $(buttonSelector).show()

    // uninstall: function() {
    //   $(document).off(".appearance")
    //   $(buttonSelector).hide()
    // },
  })

  App.appearance_vm = new Vue({
    el: "#appearance_app",
    data: function() {
      return {
        list: [],
        chat_rooms: [],
        columns: [
          { field: 'name', label: '部屋', },
        ],
      }
    },
    methods: {
      puts(v) {
        this.list.push(v)
      }
    },
    computed: {
      latest_list() {
        return _.takeRight(this.list, 10)
      },
    },
  })
})
