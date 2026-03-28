<template lang="pug">
.SbDebugBasic.column.is-12
  .columns
    .column
      .panel
        .panel-heading
          | 基本
        a.panel-block(@click="SB.room_create_from_modal('dev_room', 'alice')") 入室
        a.panel-block(@click="SB.os_setup_by_names(['alice', 'bob', 'carol', 'dave', 'ellen'])") 対局設定
        a.panel-block(@click="SB.cc_play_by()") 時計開始
    .column
      .panel.assert_var
        .panel-heading [assert_var]
        .panel-block cable_p:{{!!SB.cable_p}}
        .panel-block current_turn:{{SB.current_turn}}
        .panel-block current_turn_max:{{SB.current_turn_max}}
        .panel-block tn_bell_count:{{SB.tn_bell_count}}
        .panel-block clock_box:{{!!SB.clock_box}}
        .panel-block clock_box.current_status:{{SB.clock_box ? SB.clock_box.current_status : ''}}
        .panel-block current_title:{{SB.current_title}}
        .panel-block cc_params:{{SB.cc_params_inspect(SB.cc_params)}}
        .panel-block next_turn_message:{{SB.next_turn_message}}
        .panel-block viewpoint:{{SB.viewpoint}}

        .panel-block current_role_group:{{SB.current_role_group}}
        .panel-block room_role_group.black:{{SB.room_role_group.black}}
        .panel-block room_role_group.white:{{SB.room_role_group.white}}
        .panel-block room_role_group.other:{{SB.room_role_group.other}}
        .panel-block room_role_group.member:{{SB.room_role_group.member}}
        .panel-block query_role_group.black:{{SB.query_role_group.black}}
        .panel-block query_role_group.white:{{SB.query_role_group.white}}
        .panel-block query_role_group.other:{{SB.query_role_group.other}}
        .panel-block query_role_group.member:{{SB.query_role_group.member}}
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
