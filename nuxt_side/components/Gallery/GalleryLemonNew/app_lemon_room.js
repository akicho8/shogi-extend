export const app_lemon_room = {
  data() {
    return {
      ac_lemon_room: null, // subscriptions.create のインスタンス
      ac_lemon_room_connected_count: 0, // 接続回数
    }
  },
  mounted() {
    this.lemon_room_destroy()
    this.lemon_room_create()
  },
  beforeDestroy() {
    this.lemon_room_destroy()
  },
  methods: {
    lemon_room_create() {
      this.__assert__(this.ac_lemon_room == null, "this.ac_lemon_room == null")
      this.ac_lemon_room = this.ac_subscription_create({channel: "Gallery::LemonRoomChannel"}, {
        connected: e => {
          if (this.ac_lemon_room_connected_count === 0) {
            this.lemon_room_connected()
          }
          this.ac_lemon_room_connected_count += 1
        },
      })
    },

    lemon_room_connected() {
      this.ac_lemon_room_perform("setup_request", {})
    },

    lemon_room_destroy() {
      if (this.ac_lemon_room) {
        this.ac_unsubscribe("ac_lemon_room")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // perform のラッパーで共通のパラメータを入れる
    ac_lemon_room_perform(action, params = {}) {
      if (this.ac_lemon_room) {
        this.ac_lemon_room.perform(action, {
          ...this.ac_lemon_room_perform_default_params(),
          ...params,
        }) // --> app/channels/gallery/lemon_room_channel.rb
      }
    },

    ac_lemon_room_perform_default_params() {
      const params = {
      }
      return params
    },

    ac_log(subject = "", body = "") {
      this.ac_lemon_room_perform("ac_log", { subject, body })
    },
  },
}
