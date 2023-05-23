import { PerInfo } from "./models/per_info.js"

export const mod_per = {
  methods: {
    // 表示件数変更
    per_set_handle(info) {
      this.per_key = info.key
      this.talk(info.per)
      this.app_log_call({subject: "件数", body: info.per})
      this.page_change_or_sort_handle({per: info.per})
    },
  },
  computed: {
    PerInfo()  { return PerInfo                          },
    per_info() { return this.PerInfo.fetch(this.per_key) },
  },
}
