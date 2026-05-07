<template lang="pug">
.BranchingWarn.message.is-danger.is-small(v-if="SB.honpu_stage_info.help_message")
  .message-body
    | {{SB.honpu_stage_info.help_message}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "BranchingWarn",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"

.BranchingWarn
  &.message
    .message-body
      border-width: 0
</style>
