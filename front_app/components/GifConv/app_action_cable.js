export const app_action_cable = {
  data() {
    return {
      ac_room: null,           // subscriptions.create のインスタンス
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
      this.ac_room = this.ac_subscription_create({channel: "GifConv::RoomChannel"})
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
        }) // --> app/channels/share_board/room_channel.rb
        // this.tl_add("USER", action)
      }
    },
    ac_room_perform_default_params() {
      const params = {
        // from_connection_id: this.connection_id,     // 送信者識別子
        // from_user_name:     this.user_name,         // 送信者名
        // performed_at:       this.time_current_ms(), // 実行日時(ms)
        // active_level:       this.active_level,      // 先輩度(高い方が信憑性のある情報)
        // ua_icon_key:            this.ua_icon_key,           // 端末の種類を表すアイコン文字列
        // ac_events_hash:     this.ac_events_hash,    // イベント数(デバッグ用)
        ...params,
      }
      // if (this.g_current_user) {
      //   params.from_avatar_path = this.g_current_user.avatar_path
      // }
      return params
    },

    // // 自分で送信したものを受信した
    // received_from_self(params) {
    //   return params.from_connection_id === this.connection_id
    // },
    //
    // // 他者が送信したものを受信した
    // received_from_other(params) {
    //   return !this.received_from_self(params)
    // },

    ////////////////////////////////////////////////////////////////////////////////
    ac_log(subject = "", body = "") {
      this.ac_room_perform("ac_log", { subject, body })
    },

    henkan_record_list_broadcasted(data) {
      this.teiki_haisin = data
      if (this.henkan_record && this.teiki_haisin.owattayo_record) {
        if (this.henkan_record.id === this.teiki_haisin.owattayo_record.id) {
          this.owattayo_record = this.teiki_haisin.owattayo_record
        }
      }
    },
  },
}
