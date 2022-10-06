import { QueryPresetInfo } from "./models/query_preset_info.js"

export const app_search = {
  data() {
    return {
      query: this.$route.query.query, // 最初の検索時に b-autocomplete に入力しておくため
    }
  },

  methods: {
    // 送信ボタンを押した
    search_click_handle() {
      this.debug_alert("click")
      this.search_with_valid_handle()
    },

    // Enterキーを叩いた
    search_enter_handle() {
      this.debug_alert("enter")
      this.search_with_valid_handle()
    },

    search_with_valid_handle() {
      if (this.blank_p(this.query)) {
        this.toast_warn("なんかしら入力してから検索してください")
        return
      }
      this.interactive_search({query: this.query})
    },

    // 候補から選択した or 選択が外れた(このときはnullがくる)
    //  選択した瞬間は、まだ v-model に変化がないため this.query を参照しても何も入ってない
    //  そのかわり引数で選択したものが送られてくるのでそれを使う
    search_select_handle(user_key) {
      this.debug_alert(`select: ${user_key}`)
      if (user_key) {
        // this.talk(user_key)
        this.query = user_key
        this.interactive_search({query: this.query, page: null})
      }
    },

    // 検索すべてここで処理する
    interactive_search(params) { // private
      this.$sound.play_click()
      if (this.$fetchState.pending) {
        this.toast_ng("連打すんな")
        return
      }
      const new_params = {...this.$route.query, ...params} // フィルターなどでは query を上書きする。またはなにもしない。
      if (Number(new_params.page || 0) <= 1) {
        delete new_params.page
      }
      this.clog("new_params", new_params)
      // https://github.com/vuejs/vue-router/issues/2872
      this.$router.push({query: new_params}, () => {
        this.clog("query に変化があったので watch 経由で $fetch が呼ばれる")
      }, () => {
        this.clog("query に変化がないので watch 経由で $fetch が呼ばれない。ので自分で呼ぶ")
        this.$fetch()
      })
      // $router.push の直後に $fetch を呼ぶと nuxt.js の不具合かわからんけど、
      // $route.query が更新前の値のままなので、検索結果が異なってしまう ($nextTickも意味なし)
      // なので watch にまかせている
    },

    // b-table の @sort と @page-change に反応
    page_change_or_sort_handle(params) {
      this.$router.push({query: {...this.$route.query, ...params}}, () => {
        this.$sound.play_click()
      })
    },

    // ここだけ特別で this.query で上書きしている
    // なぜならフィルターは query に埋め込まないといけないから
    filter_research(query) {
      alert("未使用")

      if (!this.xi.current_swars_user_key) {
        this.toast_warn("先に誰かで検索してください")
        return
      }
      const new_query = _.trim(`${this.xi.current_swars_user_key} ${query}`)

      // ここで設定しておくと検索前に変更される。けどなくてもい。意味あるかな？
      this.query = new_query

      this.interactive_search({query: new_query})
    },
  },
  computed: {
    QueryPresetInfo() { return QueryPresetInfo                  },

    current_route_query() {
      return {
        query:       this.query,
        sort_column: this.xi.sort_column,
        sort_order:  this.xi.sort_order,
        ...this.$route.query,
      }
    },
  },
}
