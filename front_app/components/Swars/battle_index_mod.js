import _ from "lodash"
import dayjs from "dayjs"
import MemoryRecord from 'js-memory-record'

import battle_record_methods from "./battle_record_methods.js"
import battle_index_table_column from "./battle_index_table_column.js"

import zip_kifu_dl_mod from "./zip_kifu_dl_mod.js"
import search_form_mod from "./search_form_mod.js"
import ls_support from "./ls_support.js"

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
      search_scope_key: this.config.search_scope_key, // スコープ

      board_show_type: this.config.board_show_type, // 何の局面の表示をするか？

      sp_show_p: false,               // モーダルを開くフラグ

      loading: false,

      records: this.config.records, // 表示するレコード配列

      total: this.config.total,
      page: this.config.page,
      per: this.config.per,

      sort_column: this.config.sort_column,
      sort_order: this.config.sort_order,

      fetched_count: 0,         // fetch した回数で 1 以上でレコード配列が空だったらデータがありませんを表示する
    }
  },

  watch: {
    board_show_type(v) {
      if (v === "outbreak_turn" || v === "last") {
        // this.$gtag.event("open", {event_category: `盤面表示(${this.board_show_type_name})`})
      }
    },
  },

  methods: {
    // config_udpate() {
    //   this.search_scope_key     = this.config.search_scope_key // スコープ
    //
    //   this.board_show_type      = this.config.board_show_type  // 何の局面の表示をするか？
    //
    //   this.sp_show_p            = false                        // モーダルを開くフラグ
    //
    //   this.loading              = false
    //
    //   this.records              = this.config.records          // 表示するレコード配列
    //
    //   this.total                = this.config.total
    //   this.page                 = this.config.page
    //   this.per                  = this.config.per
    //
    //   this.sort_column          = this.config.sort_column
    //   this.sort_order           = this.config.sort_order
    //
    //   this.detailed             = true                         // 行の下に開くやつを使う？
    //   this.defaultOpenedDetails = []                           // 最初から開いておく id を入れられる
    //   this.showDetailIcon       = true                         // 行の下に開くやつ用のアイコンを表示する？
    //
    //   this.fetched_count        = 0                            // fetch した回数で 1 以上でレコード配列が空だったらデータがありませんを表示する
    // },

    show_handle(row) {
      this.sp_show_modal2(row.key, {board_show_type: this.board_show_type})
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

      alert("読んではいけない")

      // FIXME: $router.push する
      this.$axios.$get(this.async_records_load_url, {params: {}}).then(e => {
        this.loading = false
        this.records = e.records
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

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は config.modal_record にのみ入っている
    trick_start_turn_for(record) {
      if (this.board_show_type === "last") {
        return record.turn_max
      }
      return record.display_turn
    },

    piyo_shogi_app_with_params_url(record) {
      return this.piyo_shogi_auto_url({path: record.show_path, sfen: record.sfen_body, turn: this.trick_start_turn_for(record), flip: record.flip, ...record.piyo_shogi_base_params})
    },

    kento_app_with_params_url(record) {
      return this.kento_full_url({sfen: record.sfen_body, turn: this.trick_start_turn_for(record), flip: record.flip})
    },

    row_class(row, index) {
      return []
    },
  },

  mounted() {
    if (this.config.modal_record) {
      this.show_handle(this.config.modal_record)
    }

    if (this.config.current_swars_user_key) {
      // alert("リダイレクト")
      if (this.$route.query.SwarsUserShow) {
        this.user_info_show_modal(this.config.current_swars_user_key)
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
        query:             this.query,
        search_scope_key:  this.search_scope_key,
        board_show_type:   this.board_show_type,
        modal_id:          this.config.modal_record ? this.config.modal_record.key : "",
        page:              this.page,
        per:               this.per,
        sort_column:       this.sort_column,
        sort_order:        this.sort_order,
        visible_only_keys: this.visible_only_keys.join(","),
      }
    },

    async_records_load_url() {
      return this.legacy_url_build("/w.json", {...this.async_records_load_url_params, format: "json"})
    },

    // BUG: 変更になってもリアクティブにならない
    permalink_url() {
      return this.legacy_url_build("/w.json", this.async_records_load_url_params)
    },

    // id ですぐに引けるハッシュ
    records_hash() {
      return this.records.reduce((a, e, i) => ({...a, [e.id]: {code: i, ...e}}), {})
    },

    board_show_type_name() {
      return {none: "リスト", outbreak_turn: "仕掛け", last: "終局図"}[this.board_show_type]
    },

    //////////////////////////////////////////////////////////////////////////////// ls_support

    ls_key() {
      return [this.config.table_column_storage_prefix_key, "index"].join("/")
    },

    ls_data() {
      return {
        zip_kifu_key: "kif",
        visible_hash: this.as_visible_hash(this.config.table_columns_hash),
      }
    },

    ////////////////////////////////////////////////////////////////////////////////
  },
}
