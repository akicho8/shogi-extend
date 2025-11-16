<template lang="pug">
.SbDebugOrder.columns.is-multiline
  .column.is-4
    .panel
      .panel-heading
        | メンバー
      .panel-block
        | {{SB.member_infos.map(e => e.from_user_name).join(",")}}
      .panel-block
        pre {{SB.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | 順番設定 ({{SB.order_enable_p}})
      template(v-if="SB.order_unit")
        .panel-block {{SB.order_unit.inspect}}
  .column.is-4
    .panel
      .panel-heading
        | 順番操作
      template(v-if="SB.new_o.order_unit")
        .panel-block {{SB.new_o.order_unit.inspect}}
  .column.is-4
    .panel
      .panel-heading
        | 名前から引くハッシュ
      template(v-if="SB.order_unit")
        .panel-block
          pre
            | 名前→indexes
            | {{SB.name_to_turns_hash}}
        .panel-block
          pre
            | 名前→情報
            | {{SB.order_unit.name_to_object_hash}}
  .column.is-4
    .panel.assert_var
      .panel-heading
        | [assert_var]
      .panel-block order_enable_p:{{SB.order_enable_p}}
      .panel-block
        | 本順序:{{SB.order_unit.real_order_users_to_s(SB.change_per, SB.start_color)}}
      .panel-block(v-if="SB.new_o.order_unit")
        | 仮順序:{{SB.new_o.order_unit.real_order_users_to_s(SB.change_per, SB.start_color)}}
      .panel-block rs_resend_delay_id:{{SB.rs_resend_delay_id}}
  .column.is-4
    .panel
      .panel-heading
        | 順番情報(computed)
      .panel-block 0手目の色 {{SB.start_color}}
      .panel-block 自分vs自分で対戦している？ {{SB.self_vs_self_p}}
      .panel-block 1vs1で対戦している？ {{SB.one_vs_one_p}}
      .panel-block 3人以上で対戦している？ {{SB.many_vs_many_p}}
      .panel-block 対局者数 {{SB.order_unit.main_user_count}}
      .panel-block 観戦者数 {{SB.watching_member_count}}
      .panel-block 観戦者が存在する？ {{SB.watching_member_exist_p}}
      .panel-block 観戦者は二人以上いる？ {{SB.watching_member_many_p}}
      .panel-block 今の局面のメンバーの名前 {{SB.current_turn_user_name}}
      .panel-block 今は自分の手番か？ {{SB.current_turn_self_p}}
      .panel-block 次の局面のメンバーの名前 {{SB.next_turn_user_name}}
      .panel-block 次は自分の手番か？ {{SB.next_turn_self_p}}
      .panel-block 前の局面のメンバーの名前 {{SB.previous_turn_user_name}}
      .panel-block 前は自分の手番か？ {{SB.previous_turn_self_p}}
      .panel-block 自分はメンバーに含まれているか？ {{SB.i_am_member_p}}
      .panel-block 自分は観戦者か？ {{SB.i_am_watcher_p}}
      .panel-block 自分チームのメンバー数 {{SB.my_team_member_count}}
      .panel-block 自分チームのメンバーは2人以上いる？ {{SB.my_team_member_is_many_p}}
      .panel-block 自分チームのメンバーは自分だけか？ {{SB.my_team_member_is_one_p}}

  .column.is-4(v-if="SB.new_o.order_unit")
    .panel
      .panel-heading
        | new_o stringify
      .panel-block
        pre
          | {{SB.new_o.order_unit}}
  .column.is-4(v-if="SB.new_o.order_unit")
    .panel
      .panel-heading
        | new_o attributes
      .panel-block
        pre
          | {{SB.new_o.order_unit.attributes}}
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugOrder",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugOrder
  __css_keep__: 0
</style>
