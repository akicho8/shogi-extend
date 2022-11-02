export const app_user_name = {
  data() {
    return {
      // user_name: null,
    }
  },
  methods: {
    // name_setup() {
    //   // 名前の優先順位
    //   // 1. query.user_name         (URL引数)
    //   // 2. query.default_user_name (URL引数)
    //   // 3. g_current_user_name     (ログイン名)
    //   // this.user_name = this.$route.query.fixed_user_name || this.user_name
    //   // this.user_name ??= this.g_current_user_name
    //   // if (this.blank_p(this.user_name)) {
    //   //   this.user_name = this.g_current_user_name
    //   // }
    //   // if (this.present_p(this.user_name)) {
    //   //   this.medal_write()
    //   // }
    // },
  },
  // computed: {
  //   // http://localhost:4000/share-board?default_user_name=foo でハンドルネームを設定できる(主にテスト用)
  //   // persistent_cc_params の保存のタイミングで user_name が null のまま保存されると
  //   // (自分が仕掛けたチェックで)でエラーになるので空文字列を設定すること
  //   default_user_name() {
  //     return this.$route.query.default_user_name || this.g_current_user_name || ""
  //   },
  // },
}
