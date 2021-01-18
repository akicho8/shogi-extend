import { Room } from "./models/room.js"

export const application_room = {
  data() {
    return {
      room: null,              // バトル部屋情報

      // チャット用
      room_messages:     null, // メッセージ(複数)
      room_message_body: null, // 入力中のメッセージ
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

      this.room_unsubscribe()        // BOTと対戦中 new_challenge_accept_handle 経由で room_setup が呼ばれる場合もあるため必要

      this.new_challenge_snackbar_clear() // 挑戦者登場の snackbar を消去

      this.matching_interval_timer_clear() // マッチングの処理を止める

      this.room = new Room(room)

      if (this.room.bot_user_id) {
        // 練習戦なのでロビーと繋げたままにしておく
      } else {
        // 対人戦なのでロビーの接続を切る
        this.lobby_unsubscribe()
      }

      this.battle_count = 0

      this.room_speak_init()

      if (
        this.info.warp_to === "battle_sy_versus" ||
        this.info.warp_to === "battle_sy_marathon" ||
          this.info.warp_to === "battle_sy_singleton" ||
          this.info.warp_to === "battle_sy_hybrid") {
        this.battle_setup(this.info.battle)
        // return
      }

      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "Wbook::RoomChannel", room_id: this.room.id})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // room_setup connected
    // ↓
    // base/channels/wbook/room_channel.rb subscribed
    // ↓
    // base/jobs/wbook/battle_broadcast_job.rb broadcast
    // ↓
    battle_broadcasted(params) {
      if (
        this.info.warp_to === "battle_sy_versus" ||
        this.info.warp_to === "battle_sy_marathon" ||
          this.info.warp_to === "battle_sy_singleton" ||
          this.info.warp_to === "battle_sy_hybrid") {
        // this.battle_setup(this.info.battle)
        return
      }

      if (this.info.warp_to === "result") {
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
      this.$ac_battle.perform("speak", {message_body: message_body}) // --> base/channels/wbook/battle_channel.rb
    },

    debug_say(message_body) {
      if (this.base.config.action_cable_debug) {
        this.room_speak(message_body)
      }
    },

    room_speak_broadcasted(params) {
      this.lobby_speak_broadcasted_shared_process(params)
      this.room_messages.push(params.message)
    },

    ////////////////////////////////////////////////////////////////////////////////

    ac_room_perform(action, params = {}) {
      let membership = null

      if (params.ms_flip) {
        this.__assert__(typeof params.ms_flip === "boolean")
      }

      if (params.ms_flip) {
        membership = this.room_op_membership
      } else {
        membership = this.room_my_membership
      }

      params = Object.assign({}, {
        membership_id: membership.id,
      }, params)

      delete params.ms_flip

      this.$ac_room.perform(action, params) // --> base/channels/wbook/room_channel.rb
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
  computed: {
    room_my_membership() {
      const v = this.room.memberships.find(e => e.user.id === this.current_user.id)
      this.__assert__(v, "room_my_membership is blank")
      return v
    },
    room_op_membership() {
      const v = this.room.memberships.find(e => e.user.id !== this.current_user.id)
      this.__assert__(v, "room_op_membership is blank")
      return v
    },
    droped_room_messages() {
      return _.takeRight(this.room_messages, this.config.room_message_drop_lines)
    },
    // 現在のルール
    current_rule_info() {
      return this.RuleInfo.fetch(this.room.rule.key)
    },
    // 現在の戦略(sy_marathon など)
    current_strategy_key() {
      return this.current_rule_info.strategy_key
    },
    question_mode_p() {
      return false ||
        this.current_strategy_key === 'sy_marathon'  ||
        this.current_strategy_key === 'sy_singleton' ||
        this.current_strategy_key === 'sy_hybrid'
    },
    versus_mode_p() {
      return this.current_strategy_key === 'sy_versus'
    },
    emotion_folder_key() {
      if (this.question_mode_p) {
        return "question"
      } else {
        return "versus"
      }
    },
  },
}
