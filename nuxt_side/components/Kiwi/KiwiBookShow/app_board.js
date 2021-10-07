export const app_board = {
  data() {
    return {
      show_mode: "is_video",
    }
  },
  methods: {
    switch_handle() {
      this.sound_play("click")
      if (this.show_mode === "is_video") {
        if (this.main_video()) {
          this.main_video().pause()
        }
        this.show_mode = "is_board"
      } else {
        this.show_mode = "is_video"
      }
    },
    main_video() {
      return this.$refs?.KiwiBookShowMain?.$refs?.main_video
    },
  },
  computed: {
    current_share_board_params() {
      return {
        ...this.book.advanced_kif_info,
        body: this.dot_sfen_escape(this.book.advanced_kif_info.body),
      }
    },
  },
}
