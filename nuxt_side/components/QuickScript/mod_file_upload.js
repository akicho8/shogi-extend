export const mod_file_upload = {
  methods: {
    file_upload_handle(form_part, file) {
      this.clog(form_part, file)
      if (file == null) {
        this.debug_alert("なぜかファイル情報が空で呼ばれた")
        return
      }
      // this.sfx_play_click()

      const reader = new FileReader()
      reader.addEventListener("load", () => {
        this.$set(this.attributes, form_part.key, {
          name: file.name,         // "ruby-big.png"
          size: file.size,         // 196597
          type: file.type,         // "image/png"
          data_uri: reader.result, // "data:image/png;base64,XXXXXXX=="
        })
        this.toast_ok("アップロードしました")
      }, false)

      reader.readAsDataURL(file) // ここで読み取りを開始すると上の load ブロックがあとで呼ばれる (ややこしい)
    },

    file_upload_cancel_handle(form_part) {
      // this.sfx_play_click()
      this.$set(this.attributes, form_part.key, null)
      this.toast_ok("削除しました")
    },
  },
}
