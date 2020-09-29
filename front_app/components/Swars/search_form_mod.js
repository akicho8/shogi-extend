export default {
  data() {
    return {
      query: null,
    }
  },

  methods: {
    // 送信ボタンを押した
    search_click_handle() {
      this.debug_alert(`click: ${this.query}`)
      if (this.query) {
        this.debug_alert("query is blank")
        return
      }
      this.query_search(this.query)
    },

    // Enterキーを叩いた
    search_enter_handle() {
      this.debug_alert("enter")
      this.search_click_handle()
    },

    // 候補から選択した
    //  選択した瞬間は、まだ v-model に変化がないため this.query を参照しても何も入ってない
    //  そのかわり引数で選択したものが送られてくるのでそれを使う
    search_select_handle(query) {
      this.debug_alert(`select: ${query}`)
      this.query_search(query)
    },
  },
}
