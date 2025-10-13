export const mod_banana_room = {
  data() {
    return {
      ac_banana_room: null, // subscriptions.create のインスタンス
      ac_banana_room_connected_count: 0, // 接続回数
    }
  },
  mounted() {
    // this.banana_room_destroy()
    // this.banana_room_create()
  },
  beforeDestroy() {
    this.banana_room_destroy()
  },
  methods: {
    banana_room_create() {
      this.$GX.assert(this.ac_banana_room == null, "this.ac_banana_room == null")
      // alert(this.banana.id)
      this.ac_banana_room = this.ac_subscription_create({channel: "Kiwi::BananaRoomChannel", banana_id: this.banana.id}, {
        connected: e => {
          if (this.ac_banana_room_connected_count === 0) {
            this.banana_room_connected()
          }
          this.ac_banana_room_connected_count += 1
        },
      })
    },

    banana_room_connected() {
      this.ac_banana_room_perform("setup_request", {})
    },

    banana_room_destroy() {
      if (this.ac_banana_room) {
        this.ac_unsubscribe("ac_banana_room")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // perform のラッパーで共通のパラメータを入れる
    ac_banana_room_perform(action, params = {}) {
      if (this.ac_banana_room) {
        this.ac_banana_room.perform(action, {
          ...this.ac_banana_room_perform_default_params(),
          ...params,
        }) // --> app/channels/kiwi/banana_room_channel.rb
      }
    },

    ac_banana_room_perform_default_params() {
      const params = {
      }
      return params
    },

    kiwi_banana_message_pong_singlecast(data) {
      this.debug_alert(`singlecast: ${data.pong}`)
    },

    kiwi_banana_message_pong_broadcast(data) {
      this.debug_alert(`broadcast: ${data.pong}`)
    },
  },
}
