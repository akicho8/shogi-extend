<template lang="pug">
.columns.is-multiline.SwarsBattleIndexDebugPanels.is-centered
  .column.is-4
    .panel
      .panel-heading
        | Queryテスト
      template(v-for="e in DevQueryInfo.values")
        nuxt-link.panel-block(:to="{query: e.params}") {{e.name}}

  .column.is-4
    .panel
      .panel-heading
        | Methods
      a.panel-block(@click="APP.pc_data_reset") localStorageで管理する変数の初期化
      a.panel-block(@click="APP.ls_reset") localStorageのキー削除
      a.panel-block(@click="APP.column_all_set(true)") 全列表示
      a.panel-block(@click="APP.column_all_set(false)") 全列削除
      a.panel-block(@click="APP.tiresome_alert_check") ウォーズIDを記憶するダイアログ発動チェック
      a.panel-block(@click="APP.tiresome_count_increment") 自力入力した回数++
      a.panel-block(@click="APP.tiresome_alert_handle") ウォーズIDを記憶するダイアログ発動
      a.panel-block(@click="app_log({level: 'debug'})") app_log({level: 'debug'})
      a.panel-block(@click="app_log('xxx')") app_log('xxx')

  .column.is-4
    .panel
      .panel-heading
        | 保持する変数値
      .panel-block
        pre {{$GX.pretty_inspect(APP.pc_attributes)}}
  .column.is-4
    .panel
      .panel-heading
        | 保持する変数の初期値
      .panel-block
        pre {{$GX.pretty_inspect(APP.ls_default)}}

  //- .column.is-6
  //-   .panel
  //-     .panel-heading
  //-       | $data
  //-     .panel-block
  //-       pre {{APP.$data}}

  .column.is-6
    .panel
      .panel-heading
        | system_test_variables
      .panel-block.system_test_variables
        pre
          | [layout_key={{APP.layout_key}}]
          | [scene_key={{APP.scene_key}}]
          | [tiresome_count={{APP.tiresome_count}}]
          | [tiresome_previous_user_key={{APP.tiresome_previous_user_key}}]
          | [tiresome_modal_selected={{APP.tiresome_modal_selected}}]
          | [complement_user_keys={{APP.complement_user_keys.join("|")}}]
        pre(v-if="APP.xi")
          | [per={{APP.xi.per}}]
          | [records_length={{APP.xi.records ? APP.xi.records.length : ''}}]
</template>

<script>
import { support_child } from "./support_child.js"

import { DevQueryInfo } from "./models/dev_query_info.js"

export default {
  name: "SwarsBattleIndexDebugPanels",
  mixins: [support_child],
  computed: {
    DevQueryInfo() { return DevQueryInfo },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsBattleIndexDebugPanels
  __css_keep__: 0
</style>
