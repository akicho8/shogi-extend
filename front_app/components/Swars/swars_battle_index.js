// import battle_index_mod from "battle_index_mod.js"
// import usage_mod from "usage_mod.js"
//
// window.SwarsBattleIndex = Vue.extend({
//   mixins: [
//     battle_index_mod,
//     usage_mod,
//   ],
//
//   data() {
//     return {
//       submited: false,
//       detailed: false,
//     }
//   },
//
//   created() {
//     GVI.$on("query_search", e => this.query_search(e))
//   },
//
//   beforeDestroy() {
//     GVI.$off("query_search")
//   },
//
//   mounted() {
//     if (this.index_table_show_p) {
//       this.async_records_load()
//     }
//   },
//
//   computed: {
//     permalink_url() {
//       return this.query_url_build(this.query)
//     },
//
//     // 最初に一覧を表示するか？
//     index_table_show_p() {
//       // required_query_for_search の指定がなければ常に表示する
//       if (!this.config.required_query_for_search) {
//         return true
//       }
//       // テーブルを表示する条件は検索文字列があること。または modal_record があること。
//       // フォームに割り当てられている this.query だと変動するので使ってはいけない
//       return this.config.query || this.config.modal_record
//     },
//
//     search_form_complete_list() {
//       return this.config.remember_swars_user_keys.filter((option) => {
//         return option.toString().toLowerCase().indexOf(this.query.toLowerCase()) >= 0
//       })
//     }
//   },
//
//   methods: {
//     query_search(query) {
//       this.query = query
//       window.history.replaceState("", null, this.permalink_url)
//       this.async_records_load()
//     },
//
//     form_submited(e) {
//       this.process_now()
//
//       this.submited = true
//     },
//
//     query_url_build(query) {
//       const params = new URLSearchParams()
//       params.set("query", query)
//       return `/w?${params}`
//     },
//
//     row_class(row, index) {
//       if (row.judge) {
//         return `is-${row.judge.key}` // is- で始めないと mobile-cards になったとき消される
//       }
//     },
//   },
// })
