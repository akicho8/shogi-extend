export const mod_search = {
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
      if (this.$gs.blank_p(this.query)) {
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
    //
    // ↓この方法だと同じURLだとスルーされるけど href が埋め込める
    // nuxt-link(:to="{name: 'swars-search', query: {query: new_query}}" @click.native="sfx_play_click()") {{name}}
    //
    // ↓この方法だと同じURLでもアクセスする
    // a(@click="APP.interactive_search({query: new_query})") {{name}}
    interactive_search(params) { // private
      if (this.loading_p) {
        this.debug_alert("interactive_search の処理中に interactive_search が再度呼ばれている")
        return
      }

      this.sfx_play_click()
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
        this.sfx_play_click()
      })
    },

    // page_forward(1):  前に進む
    // page_forward(-1): 後ろに進む
    page_forward(plus) {
      this.page_change_or_sort_handle({page: this.next_page(plus)})
      return true
    },

    next_page(plus) {
      return Math.max(this.current_page + plus, 1)
    },
  },
  computed: {
    current_page() { return parseInt(this.$route.query.page ?? "1") },
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
