import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      user_name: null,
      persistent_cc_params: null,
    }
  },
  computed: {
    // http://0.0.0.0:4000/share-board?default_user_name=foo でハンドルネームを設定できる(主にテスト用)
    // persistent_cc_params の保存のタイミングで user_name が null のまま保存されると
    // (自分が仕掛けたチェックで)でエラーになるので空文字列を設定すること
    default_user_name() {
      return this.$route.query.default_user_name || this.g_current_user_name || ""
    },

    // ログイン名
    g_current_user_name() {
      const v = this.g_current_user
      if (v) {
        return v.name
      }
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin

    ls_storage_key() {
      return "share_board"
    },

    ls_default() {
      return {
        user_name: this.default_user_name,
        persistent_cc_params: this.default_persistent_cc_params,
      }
    },
  },
}
