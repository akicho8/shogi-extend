import _ from "lodash"

export const app_chore = {
  methods: {
    title_click_handle() {
      this.form_reset_handle()
    },

    // オプション類を外す
    form_reset_handle() {
      this.sound_play_click()
      this.pc_data_reset_resetable_only()
      this.toast_ok("オプション類を外しました")
      this.sidebar_p = false
    },

    // 完全リセット
    all_reset_handle() {
      this.sound_play_click()
      this.pc_data_reset()
      this.$router.replace({}).catch(err => {}) // "?user_key=Yamada_Taro" を外す かつ NavigationDuplicated 対策
      this.toast_ok("すべてリセットしました")
      this.sidebar_p = false
    },

    // パーマリンク化
    parmalink_handle() {
      this.sound_play_click()
      this.$router.replace({query: this.parmalink_query}).catch(err => {}) // NavigationDuplicated 対策
      this.toast_ok("URLを永続化しました")
      this.sidebar_p = false
    },
  },

  computed: {
    // permalink: true のものだけが対象
    // parmalink_query => {user_key: "xxx", vs_user_keys: "a,b", ...}
    parmalink_query() {
      const query = {}
      this.ParamInfo.values.forEach(e => {
        if (e.permalink) {
          let v = this.$data[e.key]
          if (this.present_p(v)) {
            if (Array.isArray(v)) {
              v = v.join(",")
            }
            query[e.key] = v
          }
        }
      })
      return query
    },
  },
}
