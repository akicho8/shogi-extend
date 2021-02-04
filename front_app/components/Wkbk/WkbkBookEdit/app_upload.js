export const app_upload = {
  methods: {
    upload_handle(v) {
      this.sound_play('click')
      this.book.new_file_info = v
      this.clog(v)

      const reader = new FileReader()
      reader.addEventListener("load", () => { this.book.new_file_src = reader.result }, false)
      reader.readAsDataURL(this.book.new_file_info)
    },
  },
  computed: {
    image_source() {
      return this.book.new_file_src || this.book.avatar_path
    },
  },
}
