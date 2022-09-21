<template lang="pug">
.columns.is-multiline.SbOrderPanel
  .column.is-4
    .panel
      .panel-heading
        | メンバー
      .panel-block
        | {{TheSb.member_infos.map(e => e.from_user_name).join(",")}}
      .panel-block
        pre {{TheSb.player_names_with_title_as_human_text}}
  .column.is-4
    .panel
      .panel-heading
        | 順番設定 ({{TheSb.order_enable_p}})
      template(v-if="TheSb.order_unit")
        .panel-block {{TheSb.order_unit.inspect}}
  .column.is-4
    .panel
      .panel-heading
        | 順番操作
      template(v-if="TheSb.new_v.order_unit")
        .panel-block {{TheSb.new_v.order_unit.inspect}}
  .column.is-4
    .panel
      .panel-heading
        | 名前から引くハッシュ
      template(v-if="TheSb.order_unit")
        .panel-block
          pre
            | 名前→indexes
            | {{TheSb.name_to_turns_hash}}
        .panel-block
          pre
            | 名前→情報
            | {{TheSb.order_unit.name_to_object_hash}}
  .column.is-4
    .panel
      .panel-heading
        | 順番情報(computed)
      .panel-block 0手目の色 {{TheSb.start_color}}
      .panel-block 自分vs自分で対戦している？ {{TheSb.self_vs_self_p}}
      .panel-block 1vs1で対戦している？ {{TheSb.one_vs_one_p}}
      .panel-block 3人以上で対戦している？ {{TheSb.many_vs_many_p}}
      .panel-block 対局者数 {{TheSb.order_unit.main_user_count}}
      .panel-block 観戦者数 {{TheSb.watching_member_count}}
      .panel-block 今の局面のメンバーの名前 {{TheSb.current_turn_user_name}}
      .panel-block 今は自分の手番か？ {{TheSb.current_turn_self_p}}
      .panel-block 次の局面のメンバーの名前 {{TheSb.next_turn_user_name}}
      .panel-block 次は自分の手番か？ {{TheSb.next_turn_self_p}}
      .panel-block 前の局面のメンバーの名前 {{TheSb.previous_turn_user_name}}
      .panel-block 前は自分の手番か？ {{TheSb.previous_turn_self_p}}
      .panel-block 自分はメンバーに含まれているか？ {{TheSb.self_is_member_p}}
      .panel-block 自分は観戦者か？ {{TheSb.self_is_watcher_p}}

  .column.is-4(v-if="TheSb.new_v.order_unit")
    .panel
      .panel-heading
        | new_v stringify
      .panel-block
        pre
          | {{TheSb.new_v.order_unit}}
  .column.is-4(v-if="TheSb.new_v.order_unit")
    .panel
      .panel-heading
        | new_v attributes
      .panel-block
        pre
          | {{TheSb.new_v.order_unit.attributes}}
</template>

<script>
import { support_child } from "../support_child.js"
import _ from "lodash"

export default {
  name: "SbOrderPanel",
  mixins: [support_child],
  inject: ["TheSb"],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbOrderPanel
</style>
