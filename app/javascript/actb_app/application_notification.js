export const application_notification = {
  mixins: [
  ],
  data() {
    return {
      // 通知用
      notifications: [], // 通知(複数)
      midoku_count: 0,
    }
  },

  methods: {
    notifications_setup() {
      this.api_get("notifications_fetch", {}, e => {
        this.notifications = e.notifications
        this.midoku_count = this.midoku_ids.length
      })
    },

    yomimasita_handle() {
      if (this.midoku_ids.length >= 1) {
        this.silent_api_put("yomimasita_handle", {midoku_ids: this.midoku_ids}, e => {
          this.midoku_count = 0
        })
      }
    },

    notification_singlecasted(params) {
      const notification = params.notification
      if (this.current_user) {
        // debugger
        if (notification.to_user.id !== this.current_user.id) {
          this.debug_alert("他の人に届いたのは無視")
          return
        }
        const m = notification.question_message
        let message = null
          if (m.question.user.id === this.current_user.id) {
            message = `${m.user.name}さんが${m.question.title}にコメントしました`
          } else {
            message = `以前コメントした${m.question.title}に${m.user.name}さんがコメントしました`
          }
        this.ok_notice(message)
        this.notifications = [notification, ...this.notifications]
        this.midoku_count += 1
      }
    },

    midoku_ids_get() {
      return this.notifications.filter(e => !e.opened_at).map(e => e.id)
    },
  },

  computed: {
    midoku_ids() {
      return this.notifications.filter(e => !e.opened_at).map(e => e.id)
    },
  },
}
