import _ from "lodash"

export const app_chore = {
  methods: {
    title_click_handle() {
      if (this.development_p) {
        this.form_reset_handle()
      }
    },

    // オプション類を外す
    form_reset_handle() {
      this.sound_play_click()
      this.pc_data_reset_resetable_only()
      this.sidebar_p = false
    },

    // 完全リセット
    all_reset_handle() {
      this.sound_play_click()
      this.pc_data_reset()
      this.$router.replace({}) // "?user_key=Yamada_Taro" を外す
      this.sidebar_p = false
    },
  },
}
