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
  @page-change="page => TheQS.page_change_or_sort_handle({page: page})"
  )
  template(v-for="column_name in column_names")
    b-table-column(v-slot="{row}" :field="column_name" :label="column_name" :sortable="true")
      QuickScriptViewValue(:value="row[column_name]")
  template(#empty)
    .has-text-centered No records
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export default {
  name: "QuickScriptViewValueAsTable",
  inject: ["TheQS"],
  props: ["value"],
  computed: {
    column_names() {
      const hv = {}
      this.value.rows.forEach(e => { _.each(e, (v, k) => { hv[k] = true })})
      return Object.keys(hv)
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
