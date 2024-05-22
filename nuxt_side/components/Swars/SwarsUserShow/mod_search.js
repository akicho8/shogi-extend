import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_search = {
  methods: {
    // 棋譜検索
    search_path(params = {}) {
      const query = Gs.ary_compact_blank([
        this.info.user.key,
        Gs.query_str_merge(this.$route.query.query, params),
      ]).join(" ")
      return {name: "swars-search", query: {query: query}}
    },

    // WinLoseCircle から呼ばれるシリーズ
    win_lose_click_handle(judge_info) {
      this.win_lose_click_shared_handle(judge_info)
    },
    win_lose_with_tag_click_handle(judge_info, tag) {
      Gs.assert(Gs.present_p(tag), "Gs.present_p(tag)")
      this.win_lose_click_shared_handle(judge_info, {tag: tag})
    },
    // ibi_win_lose_click_handle(judge_info) {
    //   this.win_lose_click_shared_handle(judge_info, {tag: "居飛車"})
    // },
    // furi_win_lose_click_handle(judge_info) {
    //   this.win_lose_click_shared_handle(judge_info, {tag: "振り飛車"})
    // },
    win_lose_click_shared_handle(judge_info, params = {}) {
      this.$sound.play_click()
      this.$router.push(this.search_path({"勝敗": judge_info.name, ...params}))
    },
    ////////////////////////////////////////////////////////////////////////////////

    name_click_handle() {
      this.$sound.play_click()
      this.search_by_user_key_handle()
    },

    search_by_user_key_handle() {
      this.$router.push(this.search_path())
    },

    ////////////////////////////////////////////////////////////////////////////////

    date_search_path(row) {
      return this.search_path({date: this.$time.format_ymd(row.battled_on)})
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
