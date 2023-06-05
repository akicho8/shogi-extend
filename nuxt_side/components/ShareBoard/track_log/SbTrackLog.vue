<template lang="pug">
b-table.SbTrackLog(
  :data="TheSb.track_logs"
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

export default {
  name: "SbTrackLog",
  inject: ["TheSb"],
  methods: {
    time_format(t) {
      return dayjs(t).format("HH:mm:ss.SSS")
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.SbTrackLog
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
