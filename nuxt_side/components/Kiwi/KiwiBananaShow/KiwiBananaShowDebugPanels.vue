<template lang="pug">
.KiwiBananaShowDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | banana
      .panel-block
        pre {{$GX.pretty_inspect(base.banana)}}
  .column.is-3
    .panel
      .panel-heading
        | ActionCable
      .panel-block
        p 接続回数: {{base.ac_banana_room_connected_count}}
  .column.is-3
    .panel
      .panel-heading
        | OGP
      .panel-block
        pre {{$GX.pretty_inspect(base.meta)}}
  .column.is-3(v-if="base.banana")
    .panel
      .panel-heading
        | advanced_kif_info
      .panel-block
        pre {{$GX.pretty_inspect(base.banana.advanced_kif_info)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowDebugPanels
  __css_keep__: 0
</style>
