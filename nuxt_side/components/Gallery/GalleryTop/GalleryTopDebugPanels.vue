<template lang="pug">
.GalleryTopDebugPanels.columns.is-multiline.is-centered
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{pretty_inspect(base.$data)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryTopDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.GalleryTopDebugPanels
</style>
