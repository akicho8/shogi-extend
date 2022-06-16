<template lang="pug">
// vuedraggable はスマホでも drag できる
table.table.OrderSettingModalTable
  thead
    tr
      th.order_index 順番
      th.user_name メンバー
      th.enabled_p 参加
      th.handle_element
        b-icon(icon="arrow-up-down" size="is-small")
  draggable(
    v-model="base.os_table_rows"
    handle=".handle_element"
    ghost-class="ghost_element"
    @choose="sound_play_click()"
    @end="sound_play_click()"
    @change="change_handle"
    tag="tbody"
    )
    tr(v-for="row in base.os_table_rows" :key="row.user_name")
      td.order_index
        template(v-if="row.order_index != null")
          | {{base.current_sfen_info.location_by_offset(row.order_index).name}}
          | {{row.order_index + 1}}
      td.user_name.is_line_break_on
        span(:class="{'has-text-weight-bold': row.order_index === base.order_index_by_turn(base.current_turn)}")
          | {{row.user_name}}
      td.enabled_p
        b-switch.enable_toggle_handle(:value="row.enabled_p" @input="(value) => enable_toggle_handle(row, value)")
      td.handle_element
        b-icon(icon="drag-horizontal")
</template>

<script>
import { support_child } from "./support_child.js"
import draggable from "vuedraggable"

export default {
  name: "OrderSettingModalTable",
  mixins: [support_child],
  components: {
    draggable,
  },
  props: {
    order_setting_modal: { type: Object, required: true },
  },
  methods: {
    change_handle(e) {
      this.order_setting_modal.order_index_update()
      this.base.os_change.append("順番")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.OrderSettingModalTable
  white-space: nowrap
  text-align: center
  .order_index
    width: 1%
  .user_name
    // 名前だけ幅を設定せず残りの最大幅にする
    text-align: left
  .enabled_p
    width: 1%
  .handle_element
    width: 1%
    +padding_lr(1rem)
  .ghost_element
    background-color: $white-ter // 持ち上げている要素ではなくその下の要素の背景を変える
  tbody
    .handle_element
      cursor: grab

.STAGE-development
  .OrderSettingModalTable
    td, th
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
