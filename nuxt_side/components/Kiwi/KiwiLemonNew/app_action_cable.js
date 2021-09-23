export const app_action_cable = {
  data() {
    return {
      ac_global_room: null, // subscriptions.create のインスタンス
      connected_count: 0, // 接続回数
    }
  },
  mounted() {
    this.global_room_destroy()
    this.global_room_create()
  },
  beforeDestroy() {
    this.global_room_destroy()
  },
  methods: {
    global_room_create() {
      this.__assert__(this.ac_global_room == null, "this.ac_global_room == null")
      this.ac_global_room = this.ac_subscription_create({channel: "Kiwi::GlobalRoomChannel"}, {
        connected: e => {
          if (this.connected_count === 0) {
            this.global_room_connected()
          }
          this.connected_count += 1
        },
      })
    },

    global_room_connected() {
      this.ac_global_room_perform("setup_request", {})
    },

    global_room_destroy() {
      if (this.ac_global_room) {
        this.ac_unsubscribe("ac_global_room")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // perform のラッパーで共通のパラメータを入れる
    ac_global_room_perform(action, params = {}) {
      if (this.ac_global_room) {
        this.ac_global_room.perform(action, {
          ...this.ac_global_room_perform_default_params(),
          ...params,
        }) // --> app/channels/kiwi/global_room_channel.rb
      }
    },

    ac_global_room_perform_default_params() {
      const params = {
      }
      return params
    },

    ac_log(subject = "", body = "") {
      this.ac_global_room_perform("ac_log", { subject, body })
    },
  },
}
