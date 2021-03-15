export const app_edit_mode = {
  data() {
    return {
    }
  },
  mounted() {
  },
  beforeDestroy() {
  },
  methods: {
    // 編集モード
    edit_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.sp_run_mode = "edit_mode"
    },
    // 編集完了
    play_mode_handle() {
      this.sidebar_p = false
      this.sound_play("click")
      this.sp_run_mode = "play_mode"
    },
  },
}
