<template lang="pug">
b-table.TrackLogModalTable(
  :data="SB.track_logs"
  :mobile-cards="false"
  :show-header="false"
  narrowed
  hoverable
  detailed
  detail-key="id"
  )
  b-table-column(v-slot="{row}" cell-class="cell_created_at" field="created_at") {{time_format(row.created_at)}}
  b-table-column(v-slot="{row}" cell-class="cell_section"    field="section"   ) {{row.section}}
  b-table-column(v-slot="{row}" cell-class="cell_message"    field="message"   ) {{row.message}}
  pre(slot="detail" slot-scope="props")
    | {{JSON.stringify(props.row.detail_info, null, 2)}}
</template>

<script>
import dayjs from "dayjs"
import { support_child } from "../support_child.js"

export default {
  name: "TrackLogModalTable",
  mixins: [support_child],
  methods: {
    time_format(t) {
      return dayjs(t).format("HH:mm:ss.SSS")
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

.TrackLogModalTable
  .detail-container
    padding: 0

  .cell_created_at
    __css_keep__: 0
  .cell_section
    __css_keep__: 0
  .cell_message
    width: 100%
    white-space: normal
    word-break: break-all
</style>
