export const vue_clipboard = {
  methods: {
    // const success = await clipboard_copy("text")
    clipboard_copy(text, options = {}) {
      options = {
        success_message: "コピーしました",
        failure_message: "iOSだけなぜか初回に失敗しやがるのでもう一回タップしてみてください",
        no_method_message: "この環境ではクリップボードに自動コピーすることができません",
        ...options,
      }
      if (!navigator.clipboard) {
        this.toast_ng(options.no_method_message)
        return Promise.resolve(false)
      }
      return navigator.clipboard.writeText(text).then(() => {
        this.toast_ok(options.success_message)
        return true
      }).catch(error => {
        this.toast_warn(options.failure_message)
        return false
      })
    },
  },
}
