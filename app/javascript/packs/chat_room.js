import _ from "lodash"
import axios from "axios"
import chat_room_name from "./chat_room_name.js"

// (function() {
//   this.chat_vm || (this.chat_vm = {})
// }).call(this)

// app/assets/javascripts/cable/subscriptions/chat.coffee
// App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" }
//
// # app/assets/javascripts/cable/subscriptions/lobby.coffee
// App.cable.subscriptions.create { channel: "LobbyChannel" }

document.addEventListener('DOMContentLoaded', () => {
  App.chat_room = App.cable.subscriptions.create({
    channel: "ChatRoomChannel",
    chat_room_id: chat_room_app_params.chat_room.id,
  }, {
    connected: function() {
      // Called when the subscription is ready for use on the server
      console.log("ChatRoomChannel.connected")
      // App.chat_vm.online_chat_users = _.concat(App.chat_vm.online_chat_users, chat_room_app_params.current_chat_user.id)

      this.perform("room_in", chat_room_app_params)
      this.chat_say(`<span class="has-text-primary">入室しました</span>`)

      // 入室したときに局面を反映する(これはビューの方で行なってもよい)
      App.chat_vm.kifu_body_sfen = chat_room_app_params.chat_room.kifu_body_sfen
    },
    disconnected: function() {
      console.log("ChatRoomChannel.disconnected")
      // // Called when the subscription has been terminated by the server
      // console.log("disconnected")
      // // App.chat_vm.online_chat_users = _.without(App.chat_vm.online_chat_users, chat_room_app_params.current_chat_user.id)
      this.perform("room_out", chat_room_app_params)
      this.chat_say(`<span class="has-text-primary">退出しました</span>`)
    },

    // Ruby 側の ActionCable.server.broadcast("chat_room_channel", chat_article: chat_article) に反応して呼ばれる
    received: function(data) {
      // Called when there"s incoming data on the websocket for this channel
      // console.log("received")
      // console.table(data)

      if (data["kifu_body_sfen"]) {
        console.log(data["current_chat_user"]["id"])
        console.log(chat_room_app_params.current_chat_user.id)

        if (data["current_chat_user"]["id"] === chat_room_app_params.current_chat_user.id) {
          // ブロードキャストに合わせて自分も更新すると駒音が重複してしまうため自分自身は更新しない
          // (が、こうすると本当にまわりにブロードキャストされたのか不安ではある)
        } else {
          App.chat_vm.kifu_body_sfen = data["kifu_body_sfen"]
        }
      }

      if (data["human_kifu_text"]) {
        App.chat_vm.human_kifu_text = data["human_kifu_text"]
      }

      // // 指し手の反映
      // if (data["last_hand"]) {
      //   App.chat_vm.chat_articles.push(data["last_hand"])
      // }

      if (data["online_chat_users"]) {
        App.chat_vm.online_chat_users = data["online_chat_users"]
      }

      // 発言の反映
      if (data["chat_article"]) {
        console.log("発言の反映")
        console.log(data)
        App.chat_vm.chat_articles.push(data["chat_article"])
      }

      // 部屋名の共有
      if (data["room_name"]) {
        App.chat_vm.room_name = data["room_name"]
      }
    },

    // 自由に定義してよいメソッド
    chat_say: function(chat_article_body) {
      console.log(`chat_say: ${chat_article_body}`)
      console.log(`chat_say: ${chat_room_app_params.current_chat_user.id}`)
      // app/channels/chat_room_channel.rb の chat_say メソッドに処理が渡る

      this.perform("chat_say", {
        sayed_chat_user_id: chat_room_app_params.current_chat_user.id,
        chat_room_id: chat_room_app_params.chat_room.id,
        chat_article_body: chat_article_body,
      })
    },

    // 自由に定義してよいメソッド
    room_name_changed: function(data) {
      this.perform("room_name_changed", data)
    },

    kifu_body_sfen_broadcast: function(data) {
      this.perform("kifu_body_sfen_broadcast", data)
    },
  })

  App.chat_vm = new Vue({
    mixins: [chat_room_name],
    el: "#chat_room_app",
    data() {
      return {
        kifu_body_sfen: "position startpos",  // 棋譜(shogi-player用)
        message: "",                          // 発言
        chat_articles: [],                    // 発言一覧
        online_chat_users: [],                // 参加者
        human_kifu_text: "(human_kifu_text)", // 棋譜
      }
    },
    watch: {
    },
    methods: {
      message_send(value) {
        if (this.message !== "") {
          App.chat_room.chat_say(this.message)
        }
        this.message = ""
      },

      play_mode_long_sfen_set(v) {
        const params = new URLSearchParams()
        params.append("kifu_body", v)

        axios({
          method: "post",
          timeout: 1000 * 10,
          headers: {"X-TAISEN": true},
          url: chat_room_app_params.player_mode_moved_path,
          data: params,
        }).then((response) => {
          if (response.data.error_message) {
            Vue.prototype.$toast.open({message: response.data.error_message, position: "is-bottom", type: "is-danger"})
            App.chat_room.chat_say(`<span class="has-text-danger">${response.data.error_message}</span>`)
          }
          if (response.data.kifu_body_sfen) {
            if (false) {
              // これまでの方法
              this.kifu_body_sfen = response.data.kifu_body_sfen
            } else {
              // 局面を共有する
              // /Users/ikeda/src/shogi_web/app/channels/chat_room_channel.rb の receive を呼び出してブロードキャストする

              // App.chat_room.send({...chat_room_app_params, kifu_body_sfen: response.data.sfen})

              App.chat_room.kifu_body_sfen_broadcast({...chat_room_app_params, ...response.data})
              App.chat_room.chat_say(`<span class="has-text-info">${response.data.last_hand}</span>`)
            }
          }
        }).catch((error) => {
          console.table([error.response])
          Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      },
      chat_user_self_p(chat_user) {
        return chat_user.id === chat_room_app_params.current_chat_user.id
      },
    },
    computed: {
      latest_chat_articles() {
        return _.takeRight(this.chat_articles, 10)
      },
    },
  })
})
