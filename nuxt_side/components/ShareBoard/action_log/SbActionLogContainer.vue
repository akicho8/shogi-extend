<template lang="pug">
.SbActionLogContainer.SideColumn.column.is-size-7(:class="has_content_class(SB.action_logs)")
  .SideColumnScroll(ref="SideColumnScroll")
    .SbAvatarLines
      template(v-for="(e, i) in SB.action_logs")
        SbActionLogLine(:e="e")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbActionLogContainer",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbActionLogContainer.column
  +SideColumnScrollOn
  +touch
    height: 16rem
</style>
