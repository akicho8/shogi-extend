<template lang="pug">
.KiwiBookShowDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | book
      .panel-block
        pre {{pretty_inspect(base.book)}}
  .column.is-6
    .panel
      .panel-heading
        | ActionCable
      .panel-block
        p 接続回数: {{base.ac_book_room_connected_count}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiBookShowDebugPanels
</style>
