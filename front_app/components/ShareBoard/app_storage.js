import ls_support from "@/components/models/ls_support.js"

export const app_storage = {
  mixins: [
    ls_support,
  ],
  data() {
    return {
      user_name: null,
    }
  },
  computed: {
    // http://0.0.0.0:4000/share-board?handle_name=foo でハンドルネームを設定できる(主にテスト用)
    default_user_name() {
      return this.$route.query.handle_name || this.g_current_user_name
    },

    // ログイン名
    g_current_user_name() {
      const v = this.g_current_user
      if (v) {
        return v.name
      }
    },

    //////////////////////////////////////////////////////////////////////////////// for ls_support

    ls_storage_key() {
      return "share_board"
    },

    ls_default() {
      return {
        user_name: this.default_user_name,
      }
    },
  },
}
