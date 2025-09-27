import { BookIndexColumnInfo } from "../models/book_index_column_info.js"

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
      books: null, // null:まだ読み込んでいない [...]:読み込んだ
      total: 0,

      // b-table で開いたIDたち
      detailed_keys: [],
    }
  },
  methods: {
    detail_set(enabled) {
      this.sfx_click()
      if (enabled) {
        this.detailed_keys = this.books.map(e => e.key)
      } else {
        this.detailed_keys = []
      }
    },

    tag_search_handle(tag) {
      this.sfx_click()
      this.talk(tag)
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

    tweet_handle(row) {
      let out = ""
      out += "\n"
      out += row.tweet_body + "\n"
      out += row.page_url
      this.tweet_window_popup({text: out})
    },
  },
  computed: {
    BookIndexColumnInfo()  { return BookIndexColumnInfo },

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
