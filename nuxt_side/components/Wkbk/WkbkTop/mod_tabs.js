// import { IndexScopeInfo } from "../models/index_scope_info.js"

export const mod_tabs = {
  data() {
    return {
      // tab_index: 0,       // for b-tabs v-model
      // book_counts: {}, // それぞれの箱中の問題数
    }
  },
  methods: {
    // // このタブのレコード件数
    // count_in_tab(e) {
    //   return this.book_counts[e.key] ?? 0
    // },
    // 
    // // タブが変更されたときはページをリセットする
    // tab_input_handle(index) {
    //   this.$GX.assert(index === this.tab_index, "index === this.tab_index")
    //   this.sfx_click()
    //   this.talk(this.current_scope_info.name)
    //   this.router_push({scope: this.current_scope_info.key, page: null})
    // },
  },

  computed: {
    // IndexScopeInfo()     { return IndexScopeInfo                            },
    // current_scope_info() { return this.IndexScopeInfo.fetch(this.tab_index) },
    // 
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
