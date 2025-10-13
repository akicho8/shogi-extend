<template lang="pug">
.KiwiBananaIndexDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{$GX.pretty_inspect(base.$data)}}
  //- .column.is-6(v-if="base.banana")
  //-   .panel
  //-     .panel-heading
  //-       | recipe_info
  //-     .panel-block
  //-       pre {{$GX.pretty_inspect(base.banana.lemon.recipe_info)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaIndexDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaIndexDebugPanels
  __css_keep__: 0
</style>
