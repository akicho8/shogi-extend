export const app_preview = {
  data() {
    return {
      done_record:  null,
    }
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      // this.body = ""

      // this.response_hash   = null
      // this.xconv_info    = null
      this.xconv_record = null
      this.done_record = null
      // this.xconv_record   = null
    },
    other_window_open_handle() {
      this.sound_play("click")
      this.window_popup(this.done_record.browser_url, {width: 1200, height: 630})
    },
    download_handle() {
      this.sound_play("click")
      window.location.href = this.done_record.browser_url
    },
  },
}
