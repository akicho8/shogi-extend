export const app_board = {
  data() {
    return {
      show_mode: "is_video",
    }
  },
  methods: {
    switch_handle() {
      this.sound_play_click()
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
      return this.$refs?.KiwiBananaShowMain?.$refs?.main_video
    },
  },
  computed: {
    current_share_board_params() {
      return {
        ...this.banana.advanced_kif_info,
        body: this.dot_sfen_escape(this.banana.advanced_kif_info.body),
      }
    },
  },
}
