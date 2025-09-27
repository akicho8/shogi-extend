import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export const mod_search = {
  methods: {
    // 棋譜検索
    search_path(params = {}) {
      params = {...params}
      const sort_hv = Gs.hash_extract_self(params, "sort_column", "sort_order")
      const sort_params = Gs.hash_compact_blank(sort_hv)

      const query = Gs.ary_compact_blank([
        this.info.user.key,
        Gs.query_str_merge(this.$route.query.query, params),
      ]).join(" ")

      return {name: "swars-search", query: {query: query, ...sort_params}}
    },

    ////////////////////////////////////////////////////////////////////////////////

    name_click_handle() {
      this.sfx_click()
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

    my_tag_search_path(row) {
      return this.search_path({"tag": row.tag})
    },

    vs_tag_search_path(row) {
      return this.search_path({"vs-tag": row.tag})
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
