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
    default_user_name() {
      if (this.g_current_user) {
        return this.g_current_user.name
      }
    },
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
