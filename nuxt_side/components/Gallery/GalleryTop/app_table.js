// import { GalleryRecordIndexColumnInfo } from "../models/banana_index_column_info.js"

export const app_table = {
  data() {
    return {
      // URLパラメータ
      page:        null,
      per:         null,
      tag:         null,
      // sort_column: null,
      // sort_order:  null,

      // jsonで貰うもの
      bananas: null, // null:まだ読み込んでいない [...]:読み込んだ
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
      this.sound_play_click()
      this.router_push({sort_column, sort_order})
    },
  },
  computed: {
    // GalleryRecordIndexColumnInfo()  { return GalleryRecordIndexColumnInfo },

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
