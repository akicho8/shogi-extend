<template lang="pug">
.columns.is-multiline.SwarsBattleIndexDebugPanels.is-centered
  .column.is-4
    .panel
      .panel-heading
        | Methods
      a.panel-block(@click="base.pc_data_reset") localStorageで管理する変数の初期化
      a.panel-block(@click="base.ls_reset") localStorageのキー削除
      a.panel-block(@click="base.column_all_set(true)") 全列表示
      a.panel-block(@click="base.column_all_set(false)") 全列削除
      a.panel-block(@click="base.tiresome_alert_check") ウォーズIDを覚えるダイアログ発動チェック
      a.panel-block(@click="base.tiresome_count_increment") 自力入力した回数++
      a.panel-block(@click="base.tiresome_alert_handle") ウォーズIDを覚えるダイアログ発動
      a.panel-block(@click="remote_notify") remote_notify

      nuxt-link.panel-block(:to="{query: {query: 'Yamada_Taro', error_capture_fake: true, force: true}}") 棋譜の不整合
      nuxt-link.panel-block(:to="{query: {query: 'Yamada_Taro', destroy_all: true, force: true}}") 棋譜の再取得
      nuxt-link.panel-block(:to="{query: {query: 'Yamada_Taro'}}") 棋譜の普通に取得
      nuxt-link.panel-block(:to="{query: {query: 'Yamada_Taro', viewpoint: 'black'}}") ☗を左に表示
      nuxt-link.panel-block(:to="{query: {query: 'Yamada_Taro', viewpoint: 'white'}}") ☖を左に表示
      nuxt-link.panel-block(:to="{query: {query: '', all: 'true', per: 50, debug: 'true'}}") 全レコード表示

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
          | [tiresome_key={{base.tiresome_key}}]
          | [complement_user_keys={{base.complement_user_keys.join("|")}}]
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexDebugPanels",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsBattleIndexDebugPanels
</style>
