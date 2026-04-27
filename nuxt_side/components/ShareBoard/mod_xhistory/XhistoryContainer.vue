<template lang="pug">
.XhistoryContainer.SideColumn(:class="has_content_class(SB.xhistory_records)")
  .ScrollBlock.XhistoryItems
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
@import "../stylesheets/support"
.XhistoryContainer
  +touch
    height: 16rem
  .XhistoryItems
    display: flex
    flex-direction: column
    gap: 1px // 上下の b-tag 同士が繋がってしまうのを避けるため必ず1pxあける
  font-size: $size-7
</style>
