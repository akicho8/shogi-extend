import { ArticleIndexColumnInfo } from "../models/article_index_column_info.js"
import _ from "lodash"

export const app_table = {
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
      this.sound_play('click')
      if (enabled) {
        this.detailed_keys = this.articles.map(e => e.key)
      } else {
        this.detailed_keys = []
      }
    },

    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      tag = this.tags_append(this.tag, tag).join(",")
      this.router_replace({tag})
    },

    tag_remove_handle(tag) {
      this.sound_play("click")
      tag = this.tags_remove(this.tag, tag).join(",")
      this.router_replace({tag})
    },

    page_change_handle(page) {
      if (page <= 1) {
        page = null
      }
      this.router_replace({page})
    },

    sort_handle(sort_column, sort_order) {
      this.sound_play("click")
      this.router_replace({sort_column, sort_order})
    },
  },
  computed: {
    ArticleIndexColumnInfo()  { return ArticleIndexColumnInfo },

    url_params() {
      return {
        scope:       this.scope,
        page:        this.page,
        per:         this.per,
        sort_column: this.sort_column,
        sort_order:  this.sort_order,
        tag:         this.tag,
      }
    },
  },
}
