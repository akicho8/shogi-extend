<template lang="pug">
.columns.is-multiline.SwarsCustomSearchDebugPanels.is-centered
  .column.is-4
    .panel
      .panel-heading
        | Methods
      a.panel-block(@click="base.pc_data_reset") localStorageで管理する変数の初期化
      a.panel-block(@click="base.ls_reset") localStorageのキー削除
  .column.is-4
    .panel
      .panel-heading
        | 保持する変数値
      .panel-block
        pre {{pretty_inspect(base.pc_attributes)}}
  .column.is-4
    .panel
      .panel-heading
        | 保持する変数の初期値
      .panel-block
        pre {{pretty_inspect(base.ls_default)}}
  .column.is-4
    .panel
      .panel-heading
        | $route.query
      .panel-block
        pre {{pretty_inspect(base.$route.query)}}
  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{base.$data}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
// @import "./support.sass"
// .SwarsCustomSearchDebugPanels
</style>
