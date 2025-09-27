export const mod_table = {
  data() {
    return {
      // URLパラメータ
      page:        null,
      per:         null,
      tag:         null,
      // sort_column: null,
      // sort_order:  null,
      // scope:       null,

      // jsonで貰うもの
      books: null, // null:まだ読み込んでいない [...]:読み込んだ
      // total: 0,

      // b-table で開いたIDたち
      // detailed_keys: [],
      xpage_info: null,
    }
  },
  methods: {
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
    url_params() {
      return {
        query:       this.query,
        page:        this.page,
        per:         this.per,
        tag:         this.tag,
        search_preset_key:       this.search_preset_key,
        // sort_column: this.sort_column,
        // sort_order:  this.sort_order,
      }
    },
  },
}
