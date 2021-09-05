import { UaIconInfo } from "../models/ua_icon_info.js"

export const app_devise = {
  data() {
    return {
      ua_notify_count: 0,      // ua_notify_once が呼ばれた回数
      ua_icon_key: "question", // 端末情報
    }
  },
  beforeMount() {
    this.ua_icon_key = this.ua_icon_key_get() // 何回も実行する必要がないので最初だけ
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
  computed: {
    UaIconInfo() { return UaIconInfo },
    ua_icon_info() { return this.UaIconInfo.fetch(this.ua_icon_key) },
  },
}
