<template lang="pug">
ShareBoardAvatarLine.ShareBoardMemberListOne.is-clickable(
  :base="base"
  :info="info"
  :replace_icon="replace_icon(info)"
  :key="info.from_connection_id"
  :class="base.member_info_class(info)"
  @click="row_click_handle(info)"
  )

  // 順番設定しているときに表示する番号
  .flex_item.left_tag_or_icon(v-if="base.order_lookup(info)")
    //- b-tag(rounded) {{base.order_display_index(info)}}
    | ({{base.order_display_index(info)}})

  // 反応がない場合
  //- b-icon.flex_item(v-if="base.member_is_disconnect(info)" icon="lan-disconnect" type="is-danger" size="is-small")

  .flex_item.is-size-7(v-if="base.member_is_window_blur(info)") よそ見中
  .flex_item.is-size-7(v-if="base.member_is_disconnect(info)") 応答なし
  .flex_item.is-size-7(v-if="base.member_is_self(info)") ← 自分

  template(v-if="development_p")
    .flex_item {{time_format(info)}}
    .flex_item {{info.room_joined_at}}
    .flex_item LV:{{info.active_level}}
    .flex_item 通知{{info.alive_notice_count}}回目
    .flex_item {{base.member_elapsed_sec(info)}}秒前
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMemberListOne",
  mixins: [support_child],
  props: {
    info: { type: Object, required: true, },
  },
  methods: {
    row_click_handle(info) {
      this.base.member_info_modal_handle(info)
    },
    time_format(info) {
      return dayjs(info.performed_at).format("HH:mm:ss")
    },
    replace_icon(info) {
      if (this.base.member_is_disconnect(info)) {
        return "😴"
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardMemberListOne
  &.ShareBoardAvatarLine
    &.is_window_blur
    &.is_disconnect
    &.is_self
    &.is_turn_standby
    &.is_turn_active
      font-weight: bold
</style>
