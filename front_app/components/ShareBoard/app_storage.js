import { ls_support_mixin } from "@/components/models/ls_support_mixin.js"

export const app_storage = {
  mixins: [
    ls_support_mixin,
  ],
  data() {
    return {
      share_board_column_width: null,
      user_name: null,
      persistent_cc_params: null,
    }
  },
  beforeMount() {
    if (true) {
      this.tl_add("beforeMount", "ls_setup")
      this.ls_setup() // user_name の復帰

      // URL引数を優先する(ls_setupの直後重要)
      // http://localhost:4000/share-board?autoexec=general_setting_modal_handle&sp_move_cancel=is_move_cancel_easy
      // http://localhost:4000/share-board?autoexec=general_setting_modal_handle&sp_move_cancel=is_move_cancel_hard
      // this.sp_move_cancel = this.$route.query.sp_move_cancel || this.sp_move_cancel // FIXME
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
        share_board_column_width: 80,
        user_name: this.default_user_name,
        persistent_cc_params: this.default_persistent_cc_params,
        sp_move_cancel: this.DEFAULT_VARS.sp_move_cancel,
      }
    },
  },
}
