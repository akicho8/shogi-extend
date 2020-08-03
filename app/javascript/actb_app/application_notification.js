export const application_notification = {
  mixins: [
  ],
  data() {
    return {
      // 通知用
      notifications: [], // 通知(複数)
      unopen_count: 0,
    }
  },

  methods: {
    // 通知取得
    notification_setup() {
      if (this.current_user) {
        this.api_get("notifications_fetch", {}, e => {
          this.notifications = e.notifications
          this.unopen_count = this.notification_unopen_ids.length
        })
      }
    },

    // (N)を押したので未読を空にする
    notification_opened_handle() {
      if (this.notification_unopen_ids.length >= 1) {
        this.silent_api_put("notification_opened_handle", {notification_unopen_ids: this.notification_unopen_ids}, e => {
          this.unopen_count = 0
        })
      }
    },

    // 通知を受信
    notification_singlecasted(params) {
      const notification = params.notification
      if (this.current_user) {
        this.__assert__(notification.user, "notification.user")
        if (notification.user.id !== this.current_user.id) {
          this.debug_alert("他人に届いたのは無視(自分に届く場合もある)")
          return
        }
        this.sound_play("notify")
        this.ok_notice(this.notification_to_s(notification))
        this.notifications = [notification, ...this.notifications]
        this.unopen_count += 1
      }
    },

    // 通知を実際の文字列に変換
    notification_to_s(notification) {
      const m = notification.question_message
      this.__assert__(this.current_user, "this.current_user")
      if (m.question.user.id === this.current_user.id) {
        return `${m.user.name}さんが${m.question.title}にコメントしました`
      } else {
        return `以前コメントした${m.question.title}に${m.user.name}さんがコメントしました`
      }
    },
  },

  computed: {
    // 通知の未読IDs
    notification_unopen_ids() {
      return this.notifications.filter(e => !e.opened_at).map(e => e.id)
    },
  },
}
