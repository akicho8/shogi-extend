import _ from "lodash"

export const app_chore = {
  methods: {
    title_click_handle() {
      this.form_reset_handle1()
    },

    // 「ウォーズID」以外のリセット
    form_reset_handle1() {
      this.sound_play_click()
      this.pc_data_reset_resetable_only()
      this.sidebar_p = false
    },

    // 全リセット
    form_reset_handle2() {
      this.sound_play_click()
      this.pc_data_reset()
      this.sidebar_p = false
    },
  },
}
