import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"
import dayjs from "dayjs"

export default {
  data() {
    return {
      query: this.$options.query,     // 検索文字列
      modal_p: false,                 // モーダルを開くフラグ
      current_id: null,               // 選択したレコードID

      loading: false,

      records: this.$options.records, // 表示するレコード配列

      total: this.$options.total,
      page: this.$options.page,
      per: this.$options.per,

      sort_column: this.$options.sort_column,
      sort_order: this.$options.sort_order,

      table_columns_hash: this.$options.table_columns_hash,

      defaultOpenedDetails: [], // 最初から開いておく id を入れられる
      showDetailIcon: true,
    }
  },

  methods: {
    show_handle(row) {
      this.current_id = row.id
      // const row = this.records_hash[id]

      if (row.sp_sfen) {
        this.debug_alert("棋譜はすでにある")
        this.modal_show()
        return
      }

      this.record_fetch_to(row, () => this.modal_show())
    },

    modal_show() {
      this.modal_p = true
      this.$nextTick(() => document.querySelector(".turn_slider").focus())
    },

    kifu_copy_handle(row) {
      this.debug_alert(row.kifu_copy_params)
      AppHelper.kifu_copy_exec(row.kifu_copy_params)
    },

    sort_handle(column, order) {
      this.sort_column = column
      this.sort_order = order
      this.async_records_load()
    },

    page_change_handle(page) {
      this.page = page
      this.async_records_load()
    },

    async_records_load() {
      this.loading = true

      axios({
        method: "get",
        timeout: 1000 * 60 * 10,
        url: `${this.$options.xhr_index_path}?${this.async_records_load_url_params}`,
        headers: {"X-Requested-With": "XMLHttpRequest"},
      }).then(response => {
        this.loading = false
        this.records = response.data
        console.table(this.records)
      }).catch((error) => {
        console.table([error.response])
        this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
      })
    },

    time_format(v) {
      return dayjs(v).format("YYYY-MM-DD HH:mm")
    },

    toggle(row) {
      this.$refs.table.toggleDetails(row)
    },

    details_open_handle(row) {
      this.record_fetch_to(row)
    },

    // row の棋譜がなければ取得して block があれば呼ぶ
    record_fetch_to(row, block) {
      if (row.sp_sfen) {
        this.debug_alert("棋譜はすでにある")
      } else {
        this.debug_alert("新規取得")

        axios({
          method: "get",
          timeout: 1000 * 60 * 10,
          url: row.xhr_get_path,
          headers: {"X-Requested-With": "XMLHttpRequest"},
        }).then(response => {
          this.$set(row, "sp_sfen", response.data["sp_sfen"])
          if (block) {
            block("success")
          }
          // const record = this.records.find(e => e.id === this.current_id)
          // this.$set(record, "sp_sfen", response.data["sp_sfen"])
          // this.modal_show()
        }).catch((error) => {
          console.table([error.response])
          this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },
  },

  mounted() {
    this.$refs.main_field.focus()
    this.async_records_load()
  },

  computed: {
    async_records_load_url_params() {
      return [
        `query=${this.query}`,
        `page=${this.page}`,
        `per=${this.per}`,
        `sort_column=${this.sort_column}`,
        `sort_order=${this.sort_order}`,
      ].join("&")
    },

    // id ですぐに引けるハッシュ
    records_hash() {
      return this.records.reduce((a, e, i) => ({...a, [e.id]: {code: i, ...e}}), {})
    },

    // current_id に対応するレコード
    current_record() {
      if (this.current_id) {
        return this.records_hash[this.current_id]
      }
    },

    // current_id に対応する sfen
    current_record_sp_sfen() {
      if (this.current_record) {
        return this.current_record.sp_sfen
      }
    },
  },
}
