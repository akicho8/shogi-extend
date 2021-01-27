import { BookIndexColumnInfo } from "../models/book_index_column_info.js"

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
      books: null, // null:まだ読み込んでいない [...]:読み込んだ
      total: 0,

      // b-table で開いたIDたち
      detailed_ids: [],
    }
  },
  methods: {
    detail_set(enabled) {
      this.sound_play('click')
      if (enabled) {
        this.detailed_ids = this.books.map(e => e.id)
      } else {
        this.detailed_ids = []
      }
    },

    tag_search_handle(tag) {
      this.sound_play("click")
      this.talk(tag)
      this.router_replace({tag})
    },

    page_change_handle(page) {
      if (page <= 1) {
        page = null
      }
      this.router_replace({page})
    },

    sort_handle(sort_column, sort_order) {
      this.router_replace({sort_column, sort_order})
    },
  },
  computed: {
    BookIndexColumnInfo()  { return BookIndexColumnInfo },

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
