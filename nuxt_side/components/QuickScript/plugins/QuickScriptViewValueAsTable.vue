<template lang="pug">
//- https://buefy.org/documentation/table/
b-table.QuickScriptViewValueAsTable(
  :data="value.rows"
  scrollable
  pagination-simple
  backend-pagination
  :default-sort-direction="value.sort_dir ?? 'asc'"
  :hoverable="false"
  :show-header  = "!value.header_hide"
  :mobile-cards = "!value.always_table"
  :paginated    = "value.paginated"
  :total        = "value.total"
  :current-page = "value.current_page"
  :per-page     = "value.per_page"
  @page-change="page => QS.page_change_or_sort_handle({page: page})"
  )
  //- field に設定したカラム名が指す値がソート時の対象になる
  template(v-for="column_name in column_names")
    b-table-column(
      v-slot="{row}"
      :field="column_name"
      :label="column_name_decorator(column_name)"
      :sortable="true"
      :numeric="numeric_hash[column_name]"
      )
      QuickScriptViewValue(:value="row[column_name]")
  template(#empty)
    .has-text-centered No records
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

const OPTIMIZE_ROWS = true

export default {
  name: "QuickScriptViewValueAsTable",
  inject: ["QS"],
  props: ["value"],
  methods: {
    // JS でハッシュキーに数値文字列を使うと順序が変わってしまう対策で "_7" などとしたとき実際には 7 を表示する
    column_name_decorator(colum_name) {
      return colum_name.replace(/^_/, "") // [KEYWORD] :COLUMN_NAME_PREFIX_FOR_AVOID_JS_BAD_SPEC:
    },
  },
  computed: {
    // 最初と最後の行だけ
    compact_rows() {
      let rows = this.value.rows
      if (OPTIMIZE_ROWS) {
        rows = [_.first(rows), _.last(rows)]
      }
      return rows
    },

    column_names() {
      const hv = {}
      this.compact_rows.forEach(e => { _.each(e, (v, k) => { hv[k] = true })})
      return Object.keys(hv)
    },

    // 列が数値っぽいか調べておく。
    // ハッシュ形式だと判定できないのであくまで簡易的なものである。
    numeric_hash() {
      const hv = {}
      this.column_names.forEach(column_name => {
        const numeric_like = this.compact_rows.every(row => { // every = all?
          let v = row[column_name]

          // { _v_text: 1 } 形式の場合は値だけを抽出する
          if (_.isPlainObject(v)) {
            if ("_v_text" in v) {
              v = v["_v_text"]
            }
          }

          if (false) {
          } else if (v === "" || v === null) {
            return true         // 空の場合は数値とみなす
          } else if (typeof v === 'number') {
            return true
          } else if (typeof v === 'string') {
            return /^[-+]?\d+/.test(v.trim()) // 先頭が数値で始まるなら数値と見なす
          } else {
            return false
          }
        })

        hv[column_name] = numeric_like
      })
      return hv
    },
  },
}
</script>

<style lang="sass">
.QuickScriptViewValueAsTable.b-table
  // .table
  //   width: auto
  margin-top: 0rem
  // margin-bottom: 2rem
  +mobile
    margin-top: 1rem
  td
    vertical-align: middle
</style>
