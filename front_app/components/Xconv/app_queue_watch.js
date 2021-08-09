export const app_queue_watch = {
  data() {
    return {
      xconv_info: null,
    }
  },

  methods: {
    // 変換状況を受けとる
    xconv_record_list_broadcasted(data) {
      this.xconv_info = data

      // xconv_record: フォームでPOSTしてできたもの
      // done_record: 完了したもの
      // この2つが同じなら作業が終わったことがわかる

      if (this.xconv_record && this.xconv_info.done_record) {
        if (this.xconv_record.id === this.xconv_info.done_record.id) {
          this.done_record = this.xconv_info.done_record
          if (false) {
            this.sound_stop_all()
          }
          if (this.done_record.successed_at) {
            this.sound_play("o")
            this.toast_ok("完了しました")
          }
          if (this.done_record.errored_at) {
            this.sound_play("x")
            this.toast_ok("失敗しました")
          }
        }
      }
    },
  },
}
