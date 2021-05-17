export const app_devise = {
  data() {
    return {
      ua_notify_count: 0, // ua_notify_once が呼ばれた回数
      ua_icon: null,      // 端末情報
    }
  },
  beforeMount() {
    this.ua_icon = this.ua_icon_detect() // 何回も実行する必要がないので最初だけ
  },
  methods: {
    ua_notify_once() {
      if (this.ua_notify_count === 0) {
        this.ua_notify_count += 1
        if (typeof window !== 'undefined') {
          this.ac_log("端末情報", window.navigator.userAgent || "")
        }
      }
    },
  },
}
