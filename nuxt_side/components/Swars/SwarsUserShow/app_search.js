export const app_search = {
  methods: {
    search_path(queries) {
      const query = [
        this.info.user.key,
        ...queries,
      ].join(" ")

      return {name: "swars-search", query: {query: query}}
    },

    win_lose_click_handle(judge_key) {
      this.sound_play_click()
      this.$router.push({name: "swars-search", query: {query: `${this.info.user.key} judge:${judge_key}`}})
    },

    name_click_handle() {
      this.sound_play_click()
      this.search_by_user_key_handle()
    },

    search_by_user_key_handle() {
      this.$router.push({name: "swars-search", query: {query: this.info.user.key}})
    },

    ////////////////////////////////////////////////////////////////////////////////

    date_search_path(row) {
      return this.search_path([`date:${this.date_to_ymd(row.battled_on)}`])
    },

    vs_grade_search_path(row) {
      return this.search_path([`vs-grade:${row.grade_name}`])
    },

    tag_search_path(row) {
      return this.search_path([`tag:${row.tag.name}`])
    },

    vs_tag_search_path(row) {
      return this.search_path([`vs-tag:${row.tag.name}`])
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
