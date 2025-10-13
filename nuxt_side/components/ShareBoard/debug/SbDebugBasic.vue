<template lang="pug">
.SbDebugBasic.column.is-12
  .columns
    .column
      .panel
        .panel-heading
          | 基本
        a.panel-block(@click="SB.room_create_from_modal('dev_room', 'alice')") 入室
        a.panel-block(@click="SB.os_setup_by_names(['alice', 'bob', 'carol', 'dave', 'ellen'])") 順番設定
        a.panel-block(@click="SB.cc_play_by()") 時計開始
    .column
      .panel.assert_var
        .panel-heading [assert_var]
        .panel-block ac_room:{{!!SB.ac_room}}
        .panel-block current_turn:{{SB.current_turn}}
        .panel-block tn_bell_count:{{SB.tn_bell_count}}
        .panel-block clock_box:{{!!SB.clock_box}}
        .panel-block clock_box.current_status:{{SB.clock_box ? SB.clock_box.current_status : ''}}
        .panel-block current_title:{{SB.current_title}}
        .panel-block cc_params:{{SB.cc_params_inspect(SB.cc_params)}}
        .panel-block next_turn_message:{{SB.next_turn_message}}
        .panel-block latest_illegal_name:{{SB.latest_illegal_name}}
        .panel-block viewpoint:{{SB.viewpoint}}
        .panel-block arashi_count:{{SB.arashi_count}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugBasic",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugBasic
  __css_keep__: 0
</style>
