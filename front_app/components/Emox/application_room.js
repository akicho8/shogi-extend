import { Room } from "./models/room.js"

export const application_room = {
  data() {
    return {
      room: null,              // バトル部屋情報
    }
  },

  methods: {
    ////////////////////////////////////////////////////////////////////////////////

    room_unsubscribe() {
      this.ac_unsubscribe("$ac_room")
    },

    room_setup(room) {
      this.room_unsubscribe()        // BOTと対戦中 new_challenge_accept_handle 経由で room_setup が呼ばれる場合もあるため必要

      this.matching_interval_timer_clear() // マッチングの処理を止める

      this.room = new Room(room)

      if (this.room.bot_user_id) {
        // 練習戦なのでロビーと繋げたままにしておく
      } else {
        // 対人戦なのでロビーの接続を切る
        this.lobby_unsubscribe()
      }

      this.battle_count = 0

      if (this.info.warp_to === "battle_versus") {
        this.battle_setup(this.info.battle)
      }

      this.__assert__(this.$ac_room == null, "this.$ac_room == null")
      this.$ac_room = this.ac_subscription_create({channel: "Emox::RoomChannel", room_id: this.room.id})
    },

    ////////////////////////////////////////////////////////////////////////////////

    // room_setup connected
    // ↓
    // app/channels/emox/room_channel.rb subscribed
    // ↓
    // base/jobs/emox/battle_broadcast_job.rb broadcast
    // ↓
    battle_broadcasted(params) {
      if (this.info.warp_to === "result") {
        this.battle_setup(this.info.battle)
        return
      }

      this.battle_setup(params.battle)
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

      this.$ac_room.perform(action, params) // --> app/channels/emox/room_channel.rb
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
    // 現在のルール
    current_rule_info() {
      return this.RuleInfo.fetch(this.room.rule.key)
    },
  },
}
