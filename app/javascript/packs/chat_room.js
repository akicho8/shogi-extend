import _ from "lodash"

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

document.addEventListener('DOMContentLoaded', () => {
  App.chat_room = App.cable.subscriptions.create("ChatRoomChannel", {
    connected: function() {
      console.log("connected")
      // Called when the subscription is ready for use on the server
    },
    disconnected: function() {
      console.log("disconnected")
      // Called when the subscription has been terminated by the server
    },

    // Ruby 側の ActionCable.server.broadcast("chat_room_channel", chat_article: chat_article) に反応して呼ばれる
    received: function(data) {
      // Called when there"s incoming data on the websocket for this channel
      // console.log(`received: ${data}`)

      const chat_article = data["chat_article"]
      App.chat_vm.list.push(chat_article)
    },
    // 自由に定義してよいメソッド
    chat_say: function(chat_article_body) {
      console.log(`chat_say: ${chat_article_body}`)
      // app/channels/chat_room_channel.rb の chat_say メソッドに処理が渡る
      this.perform("chat_say", {chat_article_body: chat_article_body})
    },
  })

  // $(document).on("keypress", "[data-behavior~=chat_room_speaker]", (event) => {
  //   if (event.keyCode === 13) {
  //     App.chat_room.chat_say(event.target.value)
  //     event.target.value = ""
  //     event.preventDefault()
  //   }
  // })

  App.chat_vm = new Vue({
    el: "#chat_room_app",
    data: function() {
      return {
        message: "",
        list: [],
      }
    },
    methods: {
      foo() {
        alert(1)
      },
      input_send(value) {
        App.chat_room.chat_say(this.message)
        this.message = ""
      },
    },
    computed: {
      latest_list() {
        return _.takeRight(this.list, 5)
      },
    },
  })
})
