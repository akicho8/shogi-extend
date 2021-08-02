export const app_preview = {
  data() {
    return {
      success_record:  null,
    }
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      // this.body = ""

      // this.response_hash   = null
      // this.teiki_haisin    = null
      this.henkan_record = null
      this.success_record = null
      // this.henkan_record   = null
    },
    other_window_open_handle() {
      this.sound_play("click")
      this.window_popup(this.success_record.browser_full_path, {width: 1200, height: 630})
    },
    download_handle() {
      this.sound_play("click")
      window.location.href = this.success_record.browser_full_path
    },
  },
}
