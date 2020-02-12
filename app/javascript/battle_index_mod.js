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
      query: this.$options.query,                       // 検索文字列
      search_scope_key: this.$options.search_scope_key, // スコープ

      trick_show: this.$options.trick_show, // 仕掛局面の表示をするか？
      end_show: this.$options.end_show,     // 終局図を表示するか？

      sp_modal_p: false,               // モーダルを開くフラグ
      modal_record: null,             //  選択したレコード

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
    }
  },

  watch: {
  },

  beforeCreate() {
    // 引っ越し
    if (true) {
      const old_key = `${this.$options.table_column_storage_prefix_key}/table_column_storage_key`
      const new_key = `${this.$options.table_column_storage_prefix_key}/index`
      let v = localStorage.getItem(old_key)
      if (v) {
        localStorage.setItem(new_key, JSON.stringify({visible_hash: JSON.parse(v)}))
        localStorage.removeItem(old_key)
      }
    }
  },

  methods: {
    // テーブルを表示する条件
    table_display_p() {
      return true
    },

    trick_show_handle() {
      this.trick_show = !this.trick_show
    },

    show_handle(row) {
      this.modal_record = row
      this.real_pos = this.start_turn

      if (this.modal_record.sfen_body) {
        this.debug_alert("棋譜はすでにある")
        this.sp_modal_show()
      } else {
        this.record_fetch_to(this.modal_record, () => this.sp_modal_show())
      }
    },

    sp_modal_show() {
      this.sp_modal_p = true
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

      this.http_get_command(this.async_records_load_url, {}, data => {
        this.loading = false
        this.records = data
        this.fetched_count += 1
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
          // this.sp_modal_show()
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
        visible_only_keys:  this.visible_only_keys.join(","),
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
      return [this.$options.table_column_storage_prefix_key, "index"].join("/")
    },

    ls_data() {
      return {
        zip_kifu_key: "kif",
        visible_hash: this.as_visible_hash(this.$options.table_columns_hash),
      }
    },

    ////////////////////////////////////////////////////////////////////////////////

  },
}
