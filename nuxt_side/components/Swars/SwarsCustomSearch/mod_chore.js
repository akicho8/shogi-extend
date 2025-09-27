import _ from "lodash"
import dayjs from "dayjs"

export const mod_chore = {
  methods: {
    // 戻る
    back_click_handle() {
      this.sfx_play_click()
      this.back_to_or({name: "swars-search", query: this.$gs.hash_compact_blank({query: this.user_key})})
    },

    // タイトルをクリックするとオプション類を外す
    title_click_handle() {
      this.form_reset_handle()
    },

    // オプション類を外す
    form_reset_handle() {
      this.sfx_play_click()
      this.pc_data_reset_resetable_only()
      this.toast_ok("オプション類を外しました")
      this.sidebar_p = false
    },

    // 完全リセット
    all_reset_handle() {
      this.sfx_play_click()
      this.pc_data_reset()
      this.$router.replace({}).catch(err => {}) // "?user_key=YamadaTaro" を外す かつ NavigationDuplicated 対策
      this.toast_ok("すべてリセットしました")
      this.sidebar_p = false
    },

    // パーマリンク化
    parmalink_handle() {
      this.sfx_play_click()
      this.$router.replace({query: this.parmalink_query}).catch(err => {}) // NavigationDuplicated 対策
      this.toast_ok("URLを永続化しました")
      this.sidebar_p = false
    },

    scs_time_format(seconds) {
      return this.$gs.xtime_format_human_hms(seconds)
    },
  },

  computed: {
    // パーマリンク時に付与するパラメーターのハッシュ
    // permalink: true のものだけが対象
    // parmalink_query => {user_key: "xxx", vs_user_keys: "a,b", ...}
    parmalink_query() {
      const query = {}
      this.ParamInfo.values.forEach(e => {
        if (e.permalink) {
          let v = this.$data[e.key]
          if (this.$gs.present_p(v)) {
            if (Array.isArray(v)) {
              v = v.map(e => {
                if (_.isDate(e)) {
                  return e.toISOString() // これをかまさないと英語を含む日付がパーマリンクURLに入ってしまう
                } else {
                  return e
                }
              })
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
