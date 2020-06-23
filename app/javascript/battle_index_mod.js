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
      if (v === "outbreak_turn" || v === "last") {
        this.$gtag.event("open", {event_category: `盤面表示(${this.board_show_type_name})`})
      }
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
      this.sp_show_modal({record: row, board_show_type: this.board_show_type})
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

      this.silent_remote_get(this.async_records_load_url, {}, data => {
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

    // 開始局面
    // force_turn start_turn critical_turn の順に見る
    // force_turn は $options.modal_record にのみ入っている
    trick_start_turn_for(record) {
      if (this.board_show_type === "last") {
        return record.turn_max
      }
      return record.display_turn
    },

    piyo_shogi_app_with_params_url(record) {
      return this.piyo_shogi_full_url(this.outside_app_with_params_url(record))
    },

    kento_app_with_params_url(record) {
      return this.kento_full_url({sfen: record.sfen_body, turn: this.trick_start_turn_for(record), flip: record.flip})
    },

    outside_app_with_params_url(record) {
      const params = {
        sfen: record.sfen_body,
        num: this.trick_start_turn_for(record),
        flip: record.flip,
      }
      if (record.memberships) {
        params.sente_name = this.user_key_with_grade_name(record.memberships, "black")
        params.gote_name  = this.user_key_with_grade_name(record.memberships, "white")
      }
      if (record.tournament_name) {
        params.game_name = record.tournament_name
      }
      return params
    },

    user_key_with_grade_name(memberships, location_key) {
      const membership = memberships.find(e => e.location.key === location_key)
      return `${membership.user.key} ${membership.grade_info.name}`
    },

    row_class(row, index) {
      return []
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
      return this.legacy_url_build(this.$options.xhr_index_path, {...this.async_records_load_url_params, format: "json"})
    },

    // BUG: 変更になってもリアクティブにならない
    permalink_url() {
      return this.legacy_url_build(this.$options.xhr_index_path, this.async_records_load_url_params)
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
