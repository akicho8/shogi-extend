<template lang="pug">
SbAvatarLine.SbMemberOne.is-clickable(
  :info="info"
  :replace_icon="replace_icon(info)"
  :key="info.from_connection_id"
  :class="SB.member_info_class(info)"
  @click="row_click_handle(info)"
  )

  // 順番設定しているときに表示する番号
  .flex_item.left_tag_or_icon(v-if="SB.debug_mode_p && SB.order_lookup(info)")
    | {{SB.user_name_to_display_turns(info.from_user_name)}}

  // 反応がない場合
  //- b-icon.flex_item(v-if="SB.member_is_disconnect(info)" icon="lan-disconnect" type="is-danger" size="is-small")

  .flex_item.is-size-7(v-if="SB.member_is_window_blur(info)") よそ見中
  .flex_item.is-size-7(v-if="SB.member_is_disconnect(info)") 応答なし
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
import { Location } from "shogi-player/components/models/location.js"
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
    replace_icon(info) {
      if (this.SB.member_is_disconnect(info)) {
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
    &.is_window_blur
      __css_keep__: 0
    &.is_disconnect
      __css_keep__: 0
    &.is_self
      __css_keep__: 0
    &.is_turn_standby
      __css_keep__: 0
    &.is_turn_active
      font-weight: bold
</style>
