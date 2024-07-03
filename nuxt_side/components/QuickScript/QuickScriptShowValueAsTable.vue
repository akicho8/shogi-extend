<template lang="pug">
b-table.QuickScriptShowValueAsTable(
  :data="value.rows"
  scrollable
  pagination-simple
  backend-pagination
  :paginated    = "value.paginated"
  :total        = "value.total"
  :current-page = "value.current_page"
  :per-page     = "value.per_page"
  @page-change="page => TheQS.page_change_or_sort_handle({page: page})"
  )
  template(v-for="column_name in column_names")
    b-table-column(v-slot="{row}" :field="column_name" :label="column_name")
      QuickScriptShowValue(:value="row[column_name]")
</template>

<script>
import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export default {
  name: "QuickScriptShowValueAsTable",
  inject: ["TheQS"],
  props: ["value"],
  computed: {
    column_names() {
      const hv = {}
      this.value.rows.forEach(e => {
        _.each(e, (v, k) => { hv[k] = true })
      })
      return Object.keys(hv)
    },
  },
}
</script>

<style lang="sass">
.QuickScriptShowValueAsTable.b-table
  margin-top: 0rem
  // margin-bottom: 2rem
  +mobile
    margin-top: 1rem
  td
    vertical-align: middle
</style>
