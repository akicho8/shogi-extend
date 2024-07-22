<template lang="pug">
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
  template(v-for="column_name in column_names")
    b-table-column(
      v-slot="{row}"
      :field="column_name"
      :label="column_name"
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

export default {
  name: "QuickScriptViewValueAsTable",
  inject: ["QS"],
  props: ["value"],
  computed: {
    column_names() {
      // FIXME: ここは1行目だけ見ればいいかも？
      const hv = {}
      this.value.rows.forEach(e => { _.each(e, (v, k) => { hv[k] = true })})
      return Object.keys(hv)
    },

    // 列が数値っぽいか調べておく。
    // ハッシュ形式だと判定できないのであくまで簡易的なものである。
    numeric_hash() {
      const hv = {}
      this.column_names.forEach(column_name => {
        const av = [
          _.first(this.value.rows),
          _.last(this.value.rows),
        ]
        const numeric_like = av.every(row => { // every = all?
          const v = row[column_name]
          if (false) {
          } else if (v === "" || v === null) {
            return true
          } else if (typeof v === 'number') {
            return true
          } else if (typeof v === 'string') {
            return /^[-+]?\d+/.test(v.trim())
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
  margin-top: 0rem
  // margin-bottom: 2rem
  +mobile
    margin-top: 1rem
  td
    vertical-align: middle
</style>
