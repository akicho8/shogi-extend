import book_fallback from "@/static/book_fallback.png"

export const mod_upload = {
  methods: {
    upload_handle(v) {
      this.sfx_play_click()
      this.book.new_file_info = v
      this.clog(v)

      const reader = new FileReader()
      reader.addEventListener("load", () => {
        this.book.new_file_src = reader.result
        // (falseの場合に) nullに戻してアップロード画像をすぐに削除しないようにする
        // false のまま送ると new_file_src で反映後にすぐ削除してしまう
        this.book.raw_avatar_path = null
      }, false)
      reader.readAsDataURL(this.book.new_file_info)
    },
    upload_delete_handle() {
      if (this.book.new_file_src) {
        this.sfx_play_click()
        this.toast_ok("いまアップロードした画像を削除しました")
        this.book.new_file_src = null
        return
      }
      if (this.book.raw_avatar_path) {
        this.sfx_play_click()
        this.toast_ok("既存のアップロード画像を削除しました")
        this.book.raw_avatar_path = false
        return
      }
    },
  },
  computed: {
    image_source() {
      return this.book.new_file_src || this.book.raw_avatar_path || book_fallback
    },
    image_source_exist_p() {
      return this.book.new_file_src || this.book.raw_avatar_path
    },
  },
}
