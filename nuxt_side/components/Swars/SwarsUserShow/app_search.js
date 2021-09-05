export const app_search = {
  methods: {
    search_path(queries) {
      const query = [
        this.info.user.key,
        `sample:${this.info.sample_max}`, // 直近N件の制約追加 (ない方がよさそうな気がするけどプレイヤー情報と条件を合わせる)
        ...queries,
      ].join(" ")

      return {name: "swars-search", query: {query: query}}
    },

    win_lose_click_handle(judge) {
      this.sound_play("click")
      this.$router.push({name: "swars-search", query: {query: `${this.info.user.key} judge:${judge}`}})
    },

    name_click_handle() {
      this.sound_play("click")
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
