export const support = {
  methods: {
    login_required_toast_ng() {
      if (!this.base.current_user) {
        this.toast_ng("ログインしてください")
        return true
      }
    },
  },
}
