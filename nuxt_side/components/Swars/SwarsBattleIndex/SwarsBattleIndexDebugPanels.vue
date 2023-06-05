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
      a.panel-block(@click="base.pc_data_reset") localStorageで管理する変数の初期化
      a.panel-block(@click="base.ls_reset") localStorageのキー削除
      a.panel-block(@click="base.column_all_set(true)") 全列表示
      a.panel-block(@click="base.column_all_set(false)") 全列削除
      a.panel-block(@click="base.tiresome_alert_check") ウォーズIDを記憶するダイアログ発動チェック
      a.panel-block(@click="base.tiresome_count_increment") 自力入力した回数++
      a.panel-block(@click="base.tiresome_alert_handle") ウォーズIDを記憶するダイアログ発動
      a.panel-block(@click="app_log({level: 'debug'})") app_log({level: 'debug'})
      a.panel-block(@click="app_log('xxx')") app_log('xxx')

  .column.is-4
    .panel
      .panel-heading
        | 保持する変数値
      .panel-block
        pre {{$gs.pretty_inspect(base.pc_attributes)}}
  .column.is-4
    .panel
      .panel-heading
        | 保持する変数の初期値
      .panel-block
        pre {{$gs.pretty_inspect(base.ls_default)}}

  .column.is-6
    .panel
      .panel-heading
        | $data
      .panel-block
        pre {{base.$data}}
  .column.is-6
    .panel
      .panel-heading
        | system_test_variables
      .panel-block.system_test_variables
        pre
          | [layout_key={{base.layout_key}}]
          | [scene_key={{base.scene_key}}]
          | [per={{base.xi.per}}]
          | [records_length={{base.xi.records ? base.xi.records.length : ''}}]
          | [tiresome_count={{base.tiresome_count}}]
          | [tiresome_previous_user_key={{base.tiresome_previous_user_key}}]
          | [tiresome_modal_selected={{base.tiresome_modal_selected}}]
          | [complement_user_keys={{base.complement_user_keys.join("|")}}]
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
