import { IndexScopeInfo } from "../models/index_scope_info.js"

export const app_tabs = {
  data() {
    return {
      tab_index: 0,            // for b-tabs v-model
      article_counts: {},      // それぞれの箱中の問題数
    }
  },
  methods: {
    // このタブのレコード件数
    count_in_tab(e) {
      return this.article_counts[e.key] || 0
    },

    // 指定のタブを選択
    tab_set(scope) {
      this.tab_index = this.IndexScopeInfo.fetch(scope).code
    },

    // タブが変更されたとき
    tab_input_handle(index) {
      this.sound_play("click")
      this.talk(this.current_tab.name)
      this.router_replace({scope: this.current_tab.key})
    },
  },

  computed: {
    IndexScopeInfo() { return IndexScopeInfo },

    // 現在のタブ
    current_tab() {
      return this.IndexScopeInfo.fetch(this.tab_index)
    },

    // ログインしている → 公開
    // ログインしてない → 全体
    default_scope() {
      if (this.g_current_user) {
        return "public"
      } else {
        return "everyone"
      }
    },
  },
}
