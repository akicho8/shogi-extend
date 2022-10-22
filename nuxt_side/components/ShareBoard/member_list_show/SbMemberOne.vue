<template lang="pug">
SbAvatarLine.SbMemberOne.is-clickable(
  :info="info"
  :replace_icon="replace_icon(info)"
  :key="info.from_connection_id"
  :class="TheSb.member_info_class(info)"
  @click="row_click_handle(info)"
  )

  // 順番設定しているときに表示する番号
  .flex_item.left_tag_or_icon(v-if="development_p && TheSb.order_lookup(info)")
    //- b-tag(rounded) {{TheSb.user_name_to_display_turns(info)}}
    | {{TheSb.user_name_to_display_turns(info.from_user_name)}}

  // 反応がない場合
  //- b-icon.flex_item(v-if="TheSb.member_is_disconnect(info)" icon="lan-disconnect" type="is-danger" size="is-small")

  .flex_item.is-size-7(v-if="TheSb.member_is_window_blur(info)") よそ見中
  .flex_item.is-size-7(v-if="TheSb.member_is_disconnect(info)") 応答なし
  .flex_item.is-size-7(v-if="TheSb.member_is_self(info)") ← 自分
  .flex_item.is-size-7(v-if="TheSb.current_turn_user_name === info.from_user_name") ← 今
  .flex_item.is-size-7(v-if="TheSb.next_turn_user_name === info.from_user_name") ← 次

  template(v-if="development_p")
    .flex_item {{time_format(info)}}
    .flex_item {{info.room_joined_at}}
    .flex_item LV:{{info.active_level}}
    .flex_item 通知{{info.alive_notice_count}}回目
    .flex_item {{TheSb.member_elapsed_sec(info)}}秒前
    template(v-if="TheSb.order_lookup(info)")
      | {{TheSb.user_name_to_initial_location(info.from_user_name).name}}
</template>

<script>
import { support_child } from "../support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "SbMemberOne",
  mixins: [support_child],
  inject: ["TheSb"],
  props: {
    info: { type: Object, required: true, },
  },
  methods: {
    row_click_handle(info) {
      this.TheSb.member_info_modal_handle(info)
    },
    time_format(info) {
      return dayjs(info.performed_at).format("HH:mm:ss")
    },
    replace_icon(info) {
      if (this.TheSb.member_is_disconnect(info)) {
        return "😴"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbMemberOne
  &.SbAvatarLine
    &.is_window_blur
    &.is_disconnect
    &.is_self
    &.is_turn_standby
    &.is_turn_active
      font-weight: bold
</style>
