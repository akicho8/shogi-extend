export const app_action_cable = {
  data() {
    return {
      ac_room: null, // subscriptions.create のインスタンス
    }
  },
  mounted() {
    this.room_destroy()
    this.room_create()
  },
  beforeDestroy() {
    this.room_destroy()
  },
  methods: {
    room_create() {
      this.__assert__(this.ac_room == null, "this.ac_room == null")
      this.ac_room = this.ac_subscription_create({channel: "Xconv::RoomChannel"})
    },

    room_destroy() {
      if (this.ac_room) {
        this.ac_unsubscribe("ac_room")
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

    // perform のラッパーで共通のパラメータを入れる
    ac_room_perform(action, params = {}) {
      if (this.ac_room) {
        this.ac_room.perform(action, {
          ...this.ac_room_perform_default_params(),
          ...params,
        }) // --> app/channels/xconv/room_channel.rb
      }
    },

    ac_room_perform_default_params() {
      const params = {
      }
      return params
    },

    ac_log(subject = "", body = "") {
      this.ac_room_perform("ac_log", { subject, body })
    },
  },
}
