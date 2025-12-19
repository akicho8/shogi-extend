<template lang="pug">
.SbDebugIllegal.column.is-12
  .columns.is-multiline
    .column.is-4
      .panel
        .panel-heading
          | 反則
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjFsLzVSK3JHMS84Sy84UC85LzkvOS85IGIgUCAx") 感想戦中 - 最初から王手
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ") 感想戦中 - 王手じゃない
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ&RESEND_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=lose") 対局中 - 反則したら負け
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjIvNityRzEvOEsvOFAvOS85LzkvOSBiIFAgMQ&RESEND_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 対局中 - 反則ブロック
    .column.is-4
      .panel
        .panel-heading
          | 反則テスト
        a.panel-block(href="?body=position sfen 7k1/5Gb2/7SL/8K/6s1P/9/9/9/8L b GNP 1&RESEND_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 二歩・自殺手・ピン外し自殺手・駒ワープ・死に駒・王手放置・打ち歩詰め
        a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiA4ay82YjFsLzVSK3JHMS84Sy84UC85LzkvOS85IGIgUCAx&RESEND_FEATURE=false&self_vs_self_enable_p=true&room_restore_feature_p=false&room_key=dev_room&user_name=a&FIXED_MEMBER=a&FIXED_ORDER=a&room_after_create=cc_auto_start_10m&foul_mode_key=block") 王手解除せず
    .column.is-4
      .panel.assert_var
        .panel-heading
          | [assert_var]
        .panel-block illegal_params:{{SB.illegal_params}}
        template(v-if="SB.illegal_params")
          .panel-block latest_illegal_hv:{{SB.latest_illegal_hv}}
          .panel-block latest_illegal_name:{{SB.latest_illegal_name}}
          .panel-block latest_illegal_location.key:{{SB.latest_illegal_location.key}}
          .panel-block latest_illegal_it_is_my_team:{{SB.latest_illegal_it_is_my_team}}
          .panel-block latest_illegal_it_is_op_team:{{SB.latest_illegal_it_is_op_team}}
          .panel-block latest_illegal_i_am_trigger:{{SB.latest_illegal_i_am_trigger}}
          .panel-block latest_illegal_user_name:{{SB.latest_illegal_user_name}}
          .panel-block latest_illegal_common_message:{{SB.latest_illegal_common_message}}
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
