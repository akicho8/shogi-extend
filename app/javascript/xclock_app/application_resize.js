const INNNER_HEIGHT_TO_SCREEN_HEIGHT = true // 100vh相当の範囲に実際に見えている範囲(innerHeight)を設定する

export const application_resize = {
  mounted() {
    this.window_resize_handle()
    window.addEventListener("resize", this.window_resize_handle)
  },

  beforeDestroy() {
    window.removeEventListener("resize", this.window_resize_handle)
  },

  methods: {
    window_resize_handle() {
      const height = window.innerHeight
      if (INNNER_HEIGHT_TO_SCREEN_HEIGHT) {
        document.getElementsByClassName("screen_container")[0].style.height = `${height}px`
      }
    },
  },
}
