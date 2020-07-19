import { Room } from "./models/room.js"

export const application_room = {
  data() {
    return {
      // チャット用
      room_messages: null, // メッセージ(複数)
      room_message_body:  null, // 入力中のメッセージ
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    room_unsubscribe() {
      this.ac_unsubscribe("$ac_room")
    },

    room_setup(room) {
      this.ov_user_modal_close()     // 問題を見ているときかもしれないので閉じる
      this.ov_question_modal_close() // 問題を見ているときかもしれないので閉じる

      this.room_unsubscribe()   // BOTと対戦中 yarimasu_handle 経由で room_setup が呼ばれる場合もあるため必要

      this.room = new Room(room)

      if (this.room.bot_user_id) {
        // 練習戦なのでロビーと繋げたままにしておく
      } else {
        // 対人戦なのでロビーの接続を切る
        this.lobby_unsubscribe()
      }

      this.battle_count = 0

      this.room_speak_init()

      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "Actb::RoomChannel", room_id: this.room.id})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // room_setup connected
    // ↓
    // app/channels/actb/room_channel.rb subscribed
    // ↓
    // app/jobs/actb/battle_broadcast_job.rb broadcast
    // ↓
    battle_broadcasted(params) {
      if (this.info.debug_scene === "battle_marathon_rule" || this.info.debug_scene === "battle_singleton_rule" || this.info.debug_scene === "battle_hybrid_rule") {
        this.battle_setup(this.info.battle)
        return
      }

      if (this.info.debug_scene === "result") {
        this.battle_setup(this.info.battle)
        return
      }

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

    debug_say(message_body) {
      if (this.app.config.action_cable_debug) {
        this.room_speak(message_body)
      }
    },

    room_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.room_messages.push(params.message)
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    droped_room_messages() {
      return _.takeRight(this.room_messages, this.config.room_message_drop_lines)
    },
  },
}
