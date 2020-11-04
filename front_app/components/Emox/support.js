export const support = {
  methods: {
    login_required_toast_ng() {
      if (!this.base.current_user) {
        this.toast_ng("ログインしてください")
        return true
      }
    },

    api_get(command, params, block) {
      return this.$axios.$get("/api/emox.json", {params: {remote_action: command, ...params}}).then(e => block(e))
    },

    api_put(command, params, block) {
      return this.$axios.$put("/api/emox.json", {remote_action: command, ...params}).then(e => block(e))
    },
  },
}
