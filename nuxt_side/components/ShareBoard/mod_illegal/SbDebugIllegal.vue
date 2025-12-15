<template lang="pug">
.SbDebugIllegal.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | 反則
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjFsLzVSK3JHMS84Sy84UC85LzkvOS85IGIgUCAx") 感想戦中 - 最初から王手
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ") 感想戦中 - 王手じゃない
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ&RS_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=lose") 対局中 - 反則したら負け
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ&RS_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 対局中 - 反則ブロック
    .column.is-4
      .panel
        .panel-heading
          | 反則テスト
        a.panel-block(href="?body=position sfen 7k1/5Gb2/7SL/8K/6s1P/9/9/9/8L b GNP 1&RS_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 二歩・自殺手・ピン外し自殺手・駒ワープ・死に駒・王手放置・打ち歩詰め
        a.panel-block(href="?body=position sfen 9/9/9/9/9/6+R2/6+b1k/9/8K b P 1&RS_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 王手解除せず
    .column.is-4
      .panel.assert_var
        .panel-heading
          | [assert_var]
        .panel-block latest_illegal_hv:{{SB.latest_illegal_hv}}
        .panel-block(v-if="SB.latest_illegal_hv") latest_illegal_name:{{SB.latest_illegal_hv.illegal_info.name}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugIllegal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugIllegal
  __css_keep__: 0
</style>
