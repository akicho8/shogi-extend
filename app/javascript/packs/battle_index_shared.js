import _ from "lodash"
import * as AppHelper from "./app_helper.js"
import axios from "axios"
import dayjs from "dayjs"

export default {
  data() {
    return {
      query: this.$options.query,     // 検索文字列
      search_scope_key: this.$options.search_scope_key,     // スコープ

      modal_p: false,                 // モーダルを開くフラグ
      modal_record: null,             // 選択したレコード

      loading: false,

      records: this.$options.records, // 表示するレコード配列

      total: this.$options.total,
      page: this.$options.page,
      per: this.$options.per,

      sort_column: this.$options.sort_column,
      sort_order: this.$options.sort_order,

      table_columns_hash: this.$options.table_columns_hash,

      detailed: true,           // 行の下に開くやつを使う？
      defaultOpenedDetails: [], // 最初から開いておく id を入れられる
      showDetailIcon: true,     // 行の下に開くやつ用のアイコンを表示する？

      fetched_count: 0,         // fetch した回数で 1 以上でレコード配列が空だったらデータがありませんを表示する

      sp_run_mode: "view_mode",

      real_pos: null,           // 現在表示している手数
    }
  },

  watch: {
    sp_run_mode(v) {
      if (v === "play_mode") {
        this.$toast.open({message: "駒を操作できます", position: "is-top", type: "is-info", duration: 1000 * 1})
      } else {
        this.$toast.open({message: "元に戻しました", position: "is-top", type: "is-info", duration: 1000 * 1})
      }
      this.turn_slider_focus()
    },
  },

  methods: {
    seek_to(pos) {
      this.real_pos = pos
    },

    toggle_run_mode() {
      if (this.sp_run_mode === "view_mode") {
        this.sp_run_mode = "play_mode"
      } else {
        this.sp_run_mode = "view_mode"
      }
    },

    show_handle(row) {
      this.modal_record = row
      this.real_pos = this.start_turn

      if (this.modal_record.sfen_body) {
        this.debug_alert("棋譜はすでにある")
        this.modal_show()
      } else {
        this.modal_show()
        this.record_fetch_to(this.modal_record, () => this.turn_slider_focus())
      }
    },

    modal_show() {
      this.modal_p = true
      this.turn_slider_focus()
    },

    turn_slider_focus() {
      this.$nextTick(() => {
        const dom = document.querySelector(".turn_slider")
        if (dom) {
          dom.focus()
        }
      })
    },

    kifu_copy_handle(params) {
      AppHelper.kifu_copy_exec(params)
    },

    modal_url_copy() {
      if (this.modal_record) {
        AppHelper.clipboard_copy({text: this.modal_record.tweet_modal_url})
      }
    },

    modal_url_with_turn_copy() {
      if (this.modal_record) {
        AppHelper.clipboard_copy({text: `${this.modal_record.tweet_modal_url}&turn=${this.real_pos}` })
      }
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
        url: this.async_records_load_url,
        headers: {"X-Requested-With": "XMLHttpRequest"},
      }).then(response => {
        this.loading = false
        this.records = response.data
        this.fetched_count += 1
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
      this.record_fetch_to(row) // ポップアップしないけどデータだけ取得している
    },

    // row の棋譜がなければ取得して block があれば呼ぶ
    record_fetch_to(row, block) {
      if (row.sfen_body) {
        this.debug_alert("棋譜はすでにある")
      } else {
        this.debug_alert("新規取得")

        axios({
          method: "get",
          timeout: 1000 * 60 * 10,
          url: row.sp_sfen_get_path,
          headers: {"X-Requested-With": "XMLHttpRequest"},
        }).then(response => {
          this.$set(row, "sfen_body", response.data["sfen_body"])
          if (block) {
            block("success")
          }
          // const record = this.records.find(e => e.id === this.modal_record)
          // this.$set(record, "sfen_body", response.data["sfen_body"])
          // this.modal_show()
        }).catch((error) => {
          console.table([error.response])
          this.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },
  },

  mounted() {
    if (this.$options.modal_record) {
      this.show_handle(this.$options.modal_record)
    } else {
      if (!this.query) {
        this.$refs.main_field.focus()
      }
    }

    this.async_records_load()
  },

  computed: {
    async_records_load_url_params() {
      return _.map({
        query:             this.query,
        search_scope_key:       this.search_scope_key,
        page:              this.page,
        per:               this.per,
        sort_column:       this.sort_column,
        sort_order:        this.sort_order,
        visible_columns:   this.visible_columns.join(",")
      }, (v, k) => `${k}=${v}`).join("&")
    },

    async_records_load_url() {
      return `${this.$options.xhr_index_path}.json?${this.async_records_load_url_params}`
    },

    permalink_url() {
      return `${this.$options.xhr_index_path}?${this.async_records_load_url_params}`
    },

    // id ですぐに引けるハッシュ
    records_hash() {
      return this.records.reduce((a, e, i) => ({...a, [e.id]: {code: i, ...e}}), {})
    },

    // // modal_record に対応するレコード
    // modal_record() {
    //   return this.modal_record
    //   // if (this.modal_record) {
    //   //   return this.records_hash[this.modal_record]
    //   // }
    // },

    // modal_record に対応する sfen
    // modal_record_sp_sfen() {
    //   if (this.modal_record) {
    //     return this.modal_record.sfen_body
    //   }
    // },

    // 表示している列のカラム名の配列
    visible_columns() {
      let columns
      columns = _.map(this.table_columns_hash, (attrs, key) => {
        if (attrs.visible) {
          return key
        }
      })
      return _.compact(columns)
    },

    // 開始手数
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn() {
      if (this.modal_record) {
        if ("force_turn" in this.modal_record) {
          return this.modal_record.force_turn
        } else {
          return this.modal_record.sp_turn
        }
      }
    },
  },
}
