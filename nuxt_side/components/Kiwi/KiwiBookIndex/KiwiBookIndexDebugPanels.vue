<template lang="pug">
.KiwiBookIndexDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{pretty_inspect(base.$data)}}
  //- .column.is-6(v-if="base.book")
  //-   .panel
  //-     .panel-heading
  //-       | recipe_info
  //-     .panel-block
  //-       pre {{pretty_inspect(base.book.lemon.recipe_info)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookIndexDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookIndexDebugPanels
</style>
