import _ from "lodash"
import dayjs from "dayjs"
import MemoryRecord from 'js-memory-record'

import battle_record_methods from "battle_record_methods"
import battle_index_table_column from "battle_index_table_column"

import zip_kifu_dl_mod from "zip_kifu_dl_mod"
import search_form_mod from "search_form_mod"
import ls_support from "ls_support"

export default {
  mixins: [
    battle_record_methods,
    battle_index_table_column,
    zip_kifu_dl_mod,
    search_form_mod,
    ls_support,
  ],

  data() {
    return {
      search_scope_key: this.$options.search_scope_key, // スコープ

      board_show_type: this.$options.board_show_type, // 何の局面の表示をするか？

      sp_show_p: false,               // モーダルを開くフラグ
      selected_record: null,             //  選択したレコード

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
    board_show_type(v) {
      console.log("board_show_type", v)
    },
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
    show_handle(row) {
      this.selected_record = row
      // this.turn_offset = this.start_turn // this.selected_record の start_turn を計算

      if (this.selected_record.sfen_body) {
        this.debug_alert("棋譜はすでにある")
        this.sp_show_show()
      } else {
        this.record_fetch_to(this.selected_record, () => this.sp_show_show())
      }
    },

    sp_show_show() {
      this.sp_show_modal(this.selected_record, true, this.board_show_type)
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

      this.silent_http_get_command(this.async_records_load_url, {}, data => {
        this.debug_alert(`loaded: ${data.length}`)
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
          // const record = this.records.find(e => e.id === this.selected_record)
          // this.$set(record, "sfen_body", response.data["sfen_body"])
          // this.sp_show_show()
        }).catch(error => {
          console.table([error.response])
          this.$buefy.toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
        })
      }
    },

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    trick_start_turn_for(record) {
      if (this.board_show_type === "last") {
        return record.turn_max
      }

      if ("turn" in record) {
        return record.turn
      }

      return record.display_turn
    },
  },

  mounted() {
    if (this.$options.modal_record) {
      this.show_handle(this.$options.modal_record)
    }

    if (this.$options.current_swars_user_key) {
      if (this.$route.query.user_info_show) {
        this.user_info_show_modal(this.$options.current_swars_user_key)
      }
    }
  },

  computed: {
    // テーブルを表示する条件
    index_table_show_p() {
      return true
    },

    async_records_load_url_params() {
      return {
        query:            this.query,
        search_scope_key: this.search_scope_key,
        board_show_type:  this.board_show_type,
        modal_id:         this.$options.modal_record ? this.$options.modal_record.key : null,
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

    // // selected_record に対応するレコード
    // selected_record() {
    //   return this.selected_record
    //   // if (this.selected_record) {
    //   //   return this.records_hash[this.selected_record]
    //   // }
    // },

    // selected_record に対応する sfen
    // selected_record_sp_sfen() {
    //   if (this.selected_record) {
    //     return this.selected_record.sfen_body
    //   }
    // },

    // 開始局面
    // turn start_turn critical_turn の順に見る
    // turn は $options.modal_record にのみ入っている
    // start_turn() {
    //   return this.start_turn_for(this.selected_record)
    // },

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
