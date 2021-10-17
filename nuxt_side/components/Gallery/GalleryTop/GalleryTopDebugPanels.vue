<template lang="pug">
.GalleryTopDebugPanels.columns.is-multiline.is-centered
  .column.is-4
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{pretty_inspect(base.$data)}}
  .column.is-4
    .panel
      .panel-heading
        | $config
      .panel-block
        pre {{pretty_inspect($config)}}
  .column.is-4
    .panel
      .panel-heading
        | pagination
      .panel-block
        pre {{pretty_inspect(base.pagination_info)}}
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
