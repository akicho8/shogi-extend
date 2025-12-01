<template lang="pug">
SbAvatarLine.SbMemberOne.is-clickable(
  :info="info"
  :system_icon="system_icon(info)"
  :key="info.from_connection_id"
  :class="SB.member_info_class(info)"
  @click="row_click_handle(info)"
  )

  // 順番設定しているときに表示する番号
  .flex_item.left_tag_or_icon(v-if="SB.debug_mode_p && SB.order_lookup(info)")
    | {{SB.user_name_to_display_turns(info.from_user_name)}}

  // 反応がない場合
  //- b-icon.flex_item(v-if="SB.member_is_heartbeat_lost(info)" icon="lan-disconnect" type="is-danger" size="is-small")

  .flex_item.is-size-7(v-if="SB.member_is_look_away(info)") よそ見中
  .flex_item.is-size-7(v-if="SB.member_is_heartbeat_lost(info)") 応答なし
  .flex_item.is-size-7(v-if="SB.debug_mode_p && SB.member_is_self(info)") ← 自分
  .flex_item.is-size-7(v-if="SB.current_turn_user_name === info.from_user_name") ← 今
  .flex_item.is-size-7(v-if="SB.next_turn_user_name === info.from_user_name") ← 次

  template(v-if="development_p")
    .flex_item {{time_format(info)}}
    .flex_item {{info.room_joined_at}}
    .flex_item LV:{{info.active_level}}
    .flex_item 通知{{info.alive_notice_count}}回目
    .flex_item {{SB.member_elapsed_sec(info)}}秒前
    template(v-if="SB.order_lookup(info)")
      | {{SB.user_name_to_initial_location(info.from_user_name).name}}
</template>

<script>
import dayjs from "dayjs"
import { support_child } from "../support_child.js"

export default {
  name: "SbMemberOne",
  mixins: [support_child],
  props: {
    info: { type: Object, required: true, },
  },
  methods: {
    row_click_handle(info) {
      this.SB.member_info_modal_handle(info)
    },
    time_format(info) {
      return dayjs(info.performed_at).format("HH:mm:ss")
    },
    system_icon(info) {
      if (this.SB.member_is_heartbeat_lost(info)) {
        return "😴"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbMemberOne
  &.SbAvatarLine
    &.is_look_away
      __css_keep__: 0
    &.is_heartbeat_lost
      __css_keep__: 0
    &.is_self
      __css_keep__: 0
    &.is_battle_other_player
      __css_keep__: 0
    &.is_battle_current_player
      font-weight: bold
</style>
