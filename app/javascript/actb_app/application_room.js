import { Room } from "./room.js"

import consumer from "channels/consumer"

export const application_room = {
  data() {
    return {
      // チャット用
      room_messages: null, // メッセージ(複数)
      room_message_body:  null, // 入力中のメッセージ
    }
  },

  methods: {
    room_unsubscribe() {
      if (this.$ac_room) {
        this.$ac_room.unsubscribe()
        this.$ac_room = null
        this.ac_info_update()
      }
    },

    room_setup(room) {
      this.lobby_close()

      this.room = new Room(room)

      this.battle_count = 0

      this.room_speak_init()

      this.__assert__(this.$ac_room == null)
      this.$ac_room = consumer.subscriptions.create({ channel: "Actb::RoomChannel", room_id: this.room.id }, {
        connected: () => {
          this.ac_info_update()
          this.debug_alert("room 接続")
        },
        disconnected: () => {
          this.ac_info_update()
          this.debug_alert("room 切断")
        },
        received: (data) => {
          this[data.bc_action](data.bc_params)
        },
      })
    },

    // room_setup connected
    // ↓
    // app/channels/actb/room_channel.rb subscribed
    // ↓
    // app/jobs/actb/battle_broadcast_job.rb broadcast
    // ↓
    battle_broadcasted(params) {
      this.battle_setup(params.battle)
    },

    ////////////////////////////////////////////////////////////////////////////////

    room_speak_init() {
      this.room_messages = []
      this.room_message_body = ""
    },

    room_speak_handle() {
      this.room_speak(this.room_message_body)
      this.room_message_body = ""
    },

    room_speak(message_body) {
      // 受信をバトル側にしている理由は battle_id が自明だと都合が良いため
      this.$ac_battle.perform("speak", {message_body: message_body}) // --> app/channels/actb/battle_channel.rb
    },

    room_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.room_messages.push(params.message)
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
