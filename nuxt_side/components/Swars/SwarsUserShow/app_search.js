import _ from "lodash"

export const app_search = {
  methods: {
    // 棋譜検索URL
    search_path(append_params = {}) {
      let params = {}
      if (this.present_p(this.rule)) {
        params["持ち時間"] = this.rule
      }
      if (this.present_p(this.xmode)) {
        params["モード"] = this.xmode
      }
      params = {...params, ...append_params}
      let queries = _.map(params, (value, key) => `${key}:${value}`)
      const query = [this.info.user.key, ...queries].join(" ")
      return {name: 'swars-search', query: {query: query}}
    },

    win_lose_click_handle(judge_key) {
      this.$sound.play_click()
      this.$router.push(this.search_path({'勝敗': judge_key}))
    },

    name_click_handle() {
      this.$sound.play_click()
      this.search_by_user_key_handle()
    },

    search_by_user_key_handle() {
      this.$router.push(this.search_path())
    },

    ////////////////////////////////////////////////////////////////////////////////

    date_search_path(row) {
      return this.search_path({date: this.time_format_ymd(row.battled_on)})
    },

    vs_grade_search_path(row) {
      return this.search_path({"vs-grade": row.grade_name})
    },

    tag_search_path(row) {
      return this.search_path({tag: row.tag.name})
    },

    vs_tag_search_path(row) {
      return this.search_path({"vs-tag": row.tag.name})
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
