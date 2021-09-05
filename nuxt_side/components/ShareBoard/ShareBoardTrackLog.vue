<template lang="pug">
//- .scroll_block
//- :paginated="false"
//- :per-page="200"
//- :pagination-simple="true"
b-table.ShareBoardTrackLog(
  :data="base.track_logs"
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
import { support_child } from "./support_child.js"
import dayjs from "dayjs"

export default {
  name: "ShareBoardTrackLog",
  mixins: [support_child],
  mounted() {
    // ここで実行しても効かない
    // this.base.ml_scroll_to_bottom()
  },
  methods: {
    time_format(t) {
      return dayjs(t).format("HH:mm:ss.SSS")
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardTrackLog
  // position: relative
  // height: 50vh
  // margin-bottom: 1rem

  // .scroll_block
    // @extend %overlay
    // overflow-y: auto

    // border-radius: 3px
    // background-color: $white-ter
    // padding: 0

    // .track_log
    //   line-height: 1.5
    //   padding: 0 0.5rem

  .detail-container
    padding: 0

  .cell_created_at
  .cell_section
  .cell_message
    width: 100%
    white-space: normal
    word-break: break-all
</style>
