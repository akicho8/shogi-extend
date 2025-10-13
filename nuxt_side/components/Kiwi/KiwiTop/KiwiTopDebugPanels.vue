<template lang="pug">
.KiwiTopDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{$GX.pretty_inspect(base.$data)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiTopDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiTopDebugPanels
  __css_keep__: 0
</style>
