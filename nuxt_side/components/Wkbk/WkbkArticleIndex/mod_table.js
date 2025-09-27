import { ArticleIndexColumnInfo } from "../models/article_index_column_info.js"
import _ from "lodash"

export const mod_table = {
  data() {
    return {
      // URLパラメータ
      page:        null,
      per:         null,
      sort_column: null,
      sort_order:  null,
      scope:       null,
      tag:         null,

      // jsonで貰うもの
      articles: null, // null:まだ読み込んでいない [...]:読み込んだ
      total: 0,

      // b-table で開いたIDたち
      detailed_keys: [],
    }
  },
  methods: {
    detail_set(enabled) {
      this.sfx_click()
      if (enabled) {
        this.detailed_keys = this.articles.map(e => e.key)
      } else {
        this.detailed_keys = []
      }
    },

    tag_search_handle(tag) {
      this.sfx_click()
      this.talk(tag)
      tag = this.$gs.tags_add(this.tag, tag).join(",")
      this.router_push({tag})
    },

    tag_remove_handle(tag) {
      this.sfx_click()
      tag = this.$gs.tags_remove(this.tag, tag).join(",")
      this.router_push({tag})
    },

    page_change_handle(page) {
      if (page <= 1) {
        page = null
      }
      this.router_push({page})
    },

    sort_handle(sort_column, sort_order) {
      this.sfx_click()
      this.router_push({sort_column, sort_order})
    },
  },
  computed: {
    ArticleIndexColumnInfo()  { return ArticleIndexColumnInfo },

    url_params() {
      return {
        // scope:       this.scope,
        page:        this.page,
        per:         this.per,
        sort_column: this.sort_column,
        sort_order:  this.sort_order,
        tag:         this.tag,
      }
    },
  },
}
