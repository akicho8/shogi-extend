export default {
  data() {
    return {
      query: this.config.query, // 検索文字列
    }
  },

  mounted() {
    if (this.config.modal_record) {
    } else {
      if (!this.query) {
        // b-autocomplete を入れたので不要。デスクトップであってもクリックしたタイミングで候補を出す方が便利
        // ↓
        // デスクトップのときのみフォーカスする。モバイルでは手動でフォーカスしたときにはじめて入力ツールが登場するので自動的にフォーカスしない方がいい
        // this.desktop_focus_to(this.$refs.query_field)
      }
    }

    // これも ac_focus b-autocomplete
    document.addEventListener('keypress', e => {
      if (e.code === "Enter") {
        this.auto_submit()
      }
    }, false)
  },

  methods: {
    search_handle() {
      this.auto_submit()
    },

    //////////////////////////////////////////////////////////////////////////////// すべて b-autocomplete のイベントに反応

    // フォーカスするとクエリを消す。フォーカスするということは編集するのではなく、新規でユーザー名を入力する意図があるため
    ac_focus(e) {
      this.query = ""
    },

    // 動かない。b-autocomplete で enter を押したときに submit したいがイベントが来ない
    ac_keypress_native_enter(e) {
      this.auto_submit()
    },

    // 動かない。enter は来ないらしい
    ac_typing(e) {
      if (e.code === "Enter") {
        this.auto_submit()
      }
    },

    // 動く。b-autocomplete で要素を選択したときは自動的に submit する。が、タイミングが難しい
    ac_select(e) {
      // この方法は失敗する
      // @select は単に選択したタイミングであって input の方にはまだ反映されていない
      // そのタイミングで form.submit() するから "query=" で飛んでしまう
      if (false) {
        this.auto_submit()
      }

      // この方法も失敗する
      // 次のフレームなら query はセットされているので動くはずだが "query=" で飛んでしまう
      // 原因はわからない
      if (false) {
        this.$nextTick(() => this.auto_submit())
      }

      // これは何故か動く
      // 0ms秒後に作動で結構遅れて実行しているっぽい
      // ただブラウザ依存かもしれない。0ms 後なら即時実行でいいじゃんとなってしまうと動かない
      if (false) {
        setTimeout(() => this.auto_submit(), 0)
      }

      // もっと安全にしたバージョン
      // 0.1 秒後に確認して値が入っていれば submit する
      if (true) {
        setTimeout(() => this.auto_submit(), 1000 * 0.1)
      }

      // これも動く
      // 自分で query をセットするパターン
      // ただ b-autocomplete 側でセットしてくれるのに自分で query をセットするのはおかしい
      if (false) {
        this.query = e
        this.$nextTick(() => this.auto_submit())
      }
    },

    // private

    // フォームに値があれば submit する
    auto_submit() {
      // if (this.$refs.search_form) {
      if (_.trim(this.query) !== "") {
        // this.$buefy.loading.open()
        this.query_search(this.query)
        // this.$refs.search_form.submit()
      }
      // }
    },

    // // フォームに値があれば submit する
    // auto_submit() {
    //   if (this.$refs.search_form) {
    //     if (_.trim(this.query) !== "") {
    //       this.$buefy.loading.open()
    //       this.$refs.search_form.submit()
    //     }
    //   }
    // },
  },
}
