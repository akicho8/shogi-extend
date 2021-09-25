import { IndexScopeInfo } from "../models/index_scope_info.js"

export const app_tabs = {
  data() {
    return {
    }
  },
  methods: {
  },

  computed: {
    IndexScopeInfo()     { return IndexScopeInfo                        },
    current_scope_info() { return this.IndexScopeInfo.fetch(this.scope) },

    // // ログインしている → 公開
    // // ログインしてない → 全体
    // default_scope() {
    //   if (this.g_current_user) {
    //     return "public"
    //   } else {
    //     return "everyone"
    //   }
    // },
  },
}
