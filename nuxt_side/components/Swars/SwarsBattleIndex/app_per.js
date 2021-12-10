import { PerInfo } from "./models/per_info.js"

export const app_per = {
  methods: {
    // 表示件数変更
    per_set_handle(info) {
      this.per_key = info.key
      this.talk(info.per)

      const params = {}
      // if (info.key !== this.base.ParamInfo.fetch("per_key").default_for(this.base)) {
      params.per = info.per
      // }

      this.page_change_or_sort_handle(params)
    },
  },
  computed: {
    PerInfo()  { return PerInfo                          },
    per_info() { return this.PerInfo.fetch(this.per_key) },
  },
}
