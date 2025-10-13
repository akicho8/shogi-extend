<template lang="pug">
.columns.is-multiline.KiwiLemonNewDebugPanels.is-centered
  .column.is-4
    .panel
      .panel-heading 操作
      a.panel-block(@click="base.banana_new_handle(base.my_records[0])") ライブラリ登録

  .column.is-4
    .panel
      .panel-heading post_params
      .panel-block
        pre {{$GX.pretty_inspect(base.post_params)}}
  .column.is-4(v-if="base.response_hash")
    .panel
      .panel-heading response_hash
      .panel-block
        pre {{$GX.pretty_inspect(base.response_hash)}}
  .column.is-4(v-if="base.done_record")
    .panel
      .panel-heading done_record
      .panel-block
        pre {{$GX.pretty_inspect(base.done_record)}}
  .column.is-4(v-if="base.xaudio_list")
    .panel
      .panel-heading xaudio_list
      .panel-block
        pre {{$GX.pretty_inspect(base.xaudio_list)}}
      .panel-block
        pre {{$GX.pretty_inspect(base.xaudio_list_for_v_model)}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
.KiwiLemonNewDebugPanels
  __css_keep__: 0
</style>
