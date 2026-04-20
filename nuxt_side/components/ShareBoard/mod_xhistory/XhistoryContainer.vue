<template lang="pug">
.XhistoryContainer.SideColumn.column.is-size-7(:class="has_content_class(SB.xhistory_records)")
  .SideColumnScroll(ref="SideColumnScroll")
    .XhistoryItems
      template(v-for="(e, i) in SB.xhistory_records")
        XhistoryItem(:e="e")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "XhistoryContainer",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../scss/support"
.XhistoryContainer.column
  +SideColumnScrollOn
  +touch
    height: 16rem
  .XhistoryItems
    display: flex
    flex-direction: column
    gap: 1px // 上下の b-tag 同士が繋がってしまうのを避けるため必ず1pxあける
</style>
