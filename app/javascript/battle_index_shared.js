import _ from "lodash"
import dayjs from "dayjs"
import MemoryRecord from 'js-memory-record'

import battle_record_methods from "battle_record_methods.js"
import battle_index_table_column from "battle_index_table_column.js"

import zip_kifu_dl_mod from "zip_kifu_dl_mod.js"
import ls_support from "ls_support.js"

export default {
  mixins: [
    battle_record_methods,
    battle_index_table_column,
    zip_kifu_dl_mod,
    ls_support,
  ],

  data() {
    return {
      query: this.$options.query,     // 検索文字列
      search_scope_key: this.$options.search_scope_key,     // スコープ
      trick_show: this.$options.trick_show,
      end_show: this.$options.end_show,

      modal_p: false,                 // モーダルを開くフラグ
      modal_record: null,             // 選択したレコード

      loading: false,

      records: this.$options.records, // 表示するレコード配列

      total: this.$options.total,
      page: this.$options.page,
      per: this.$options.per,

      sort_column: this.$options.sort_column,
      sort_order: this.$options.sort_order,

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
        this.$buefy.toast.open({message: "駒を操作できます", position: "is-top", type: "is-info", duration: 1000 * 1})
      } else {
        this.$buefy.toast.open({message: "元に戻しました", position: "is-top", type: "is-info", duration: 1000 * 1})
      }
      this.turn_slider_focus()
    },
  },

  methods: {
    // テーブルを表示する条件
    table_display_p() {
      return true
    },

    trick_show_handle() {
      this.trick_show = !this.trick_show
    },

    seek_to(pos) {
      this.real_pos = pos
    },

    // 未使用
    // toggle_run_mode() {
    //   if (this.sp_run_mode === "view_mode") {
    //     this.sp_run_mode = "play_mode"
    //   } else {
    //     this.sp_run_mode = "view_mode"
    //   }
    // },

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
      this.kifu_copy_exec(params)
    },

    modal_url_copy() {
      if (this.modal_record) {
        this.clipboard_copy({text: this.modal_record.modal_on_index_url})
      }
    },

    modal_url_with_turn_copy() {
      if (this.modal_record) {
        this.clipboard_copy({text: `${this.modal_record.modal_on_index_url}&turn=${this.real_pos}` })
      }
    },

    // modal_url_with_turn_copy2() {
    //   if (this.modal_record) {
    //     this.modal_record.
    //
    //
    //     this.clipboard_copy({text: `${this.modal_record.modal_on_index_url}&turn=${this.real_pos}` })
    //   }
    // },

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

      this.$http.get(this.async_records_load_url).then(response => {
        this.loading = false
        this.records = response.data
        this.fetched_count += 1
      }).catch(error => {
        console.table([error.response])
        this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
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

        this.$http.get(row.sp_sfen_get_path).then(response => {
          this.$set(row, "sfen_body", response.data["sfen_body"])
          if (block) {
            block("success")
          }
          // const record = this.records.find(e => e.id === this.modal_record)
          // this.$set(record, "sfen_body", response.data["sfen_body"])
          // this.modal_show()
        }).catch(error => {
          console.table([error.response])
          this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn_for(record) {
      if (record) {
        if (this.end_show) {
          return record.turn_max
        }

        if ("force_turn" in record) {
          return record.force_turn
        } else {
          return record.sp_turn
        }
      }
    },
  },

  mounted() {
    if (this.$options.modal_record) {
      this.show_handle(this.$options.modal_record)
    } else {
      if (!this.query) {
        // モバイルでは手動でフォーカスしたときにはじめて入力ツールが登場するので自動的にフォーカスしない方がいい
        this.desktop_only_focus(this.$refs.query_field)
      }
    }
  },

  computed: {
    async_records_load_url_params() {
      return {
        query:            this.query,
        search_scope_key: this.search_scope_key,
        trick_show:       this.trick_show,
        end_show:         this.end_show,
        page:             this.page,
        per:              this.per,
        sort_column:      this.sort_column,
        sort_order:       this.sort_order,
        visible_columns:  this.visible_columns.join(","),
      }
    },

    async_records_load_url() {
      return `${this.$options.xhr_index_path}.json?${this.url_build(this.async_records_load_url_params)}`
    },

    permalink_url() {
      return `${this.$options.xhr_index_path}?${this.url_build(this.async_records_load_url_params)}`
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

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    start_turn() {
      return this.start_turn_for(this.modal_record)
    },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_key() {
      return [this.$options.table_column_storage_prefix_key, "main"].join("/")
    },

    ls_data() {
      return {
        zip_kifu_key: "kif",
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

  },
}
