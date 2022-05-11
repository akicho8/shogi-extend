<template lang="pug">
.ShareBoardMemberList.BothSideColumn.column(:class="{'content_blank_p': blank_p(member_infos)}")
  .is-hidden-tablet.is-size-7.has-text-weight-bold メンバー
  .scroll_block(ref="scroll_block")
    template(v-for="e in member_infos")
      ShareBoardAvatarLine.member_one_line.is-clickable(
        :base="base"
        :info="e"
        :replace_icon="replace_icon(e)"
        :key="e.from_connection_id"
        :class="base.member_info_class(e)"
        @click="row_click_handle(e)"
        )

        // 順番設定しているときに表示する番号
        .flex_item.left_tag_or_icon(v-if="base.order_lookup(e)")
          //- b-tag(rounded) {{base.order_display_index(e)}}
          | ({{base.order_display_index(e)}})

        // 反応がない場合
        //- b-icon.flex_item(v-if="base.member_is_disconnect(e)" icon="lan-disconnect" type="is-danger" size="is-small")

        .flex_item.is-size-7(v-if="base.member_is_window_blur(e)") よそ見中
        .flex_item.is-size-7(v-if="base.member_is_disconnect(e)") 応答なし
        .flex_item.is-size-7(v-if="base.member_is_self(e)") ← 自分

        template(v-if="development_p")
          .flex_item {{time_format(e)}}
          .flex_item {{e.room_joined_at}}
          .flex_item LV:{{e.active_level}}
          .flex_item 通知{{e.alive_notice_count}}回目
          .flex_item {{base.member_elapsed_sec(e)}}秒前
</template>

<script>
import { support_child } from "./support_child.js"
import dayjs from "dayjs"
import { Location } from "shogi-player/components/models/location.js"

export default {
  name: "ShareBoardMemberList",
  mixins: [support_child],
  methods: {
    row_click_handle(e) {
      this.base.member_info_modal_handle(e)
    },
    time_format(e) {
      return dayjs(e.performed_at).format("HH:mm:ss")
    },
    replace_icon(e) {
      if (this.base.member_is_disconnect(e)) {
        return "😴"
      }
    },
  },
  computed: {
    member_infos() {
      if (this.base.order_enable_p) {
        if (this.base.ordered_members) {
          return _.sortBy(this.base.member_infos, e => {
            let found = null
            if (false) {
              found = this.base.ordered_members.find(v => v.user_name === e.from_user_name) // O(n)
            } else {
              found = this.base.user_names_hash[e.from_user_name] // O(1)
            }
            if (found) {
              return found.order_index
            } else {
              // 見つからなかった人は「観戦」なので一番下に移動させておく
              return this.base.member_infos.length
            }
          })
        }
      }
      return this.base.member_infos
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardMemberList.column
  .scroll_block
    +is_scroll_x
    padding: 0

    .time_format
      vertical-align: middle
    .ShareBoardAvatarLine
      line-height: 2.25
      padding: 0.2rem 0rem
      color: inherit
      // &:hover
      //   background-color: $white-ter

    // .left_tag_or_icon
    //   .tag
    //     background-color: unset
    //     padding: 0 0.4rem

    .ShareBoardAvatarLine
      &.is_window_blur
      &.is_disconnect
      &.is_self
      &.is_turn_standby
      &.is_turn_active
        font-weight: bold
        // .left_tag_or_icon
        //   .tag
        //     border: 2px solid $primary

.ShareBoardMemberList.column
  // モバイルのときは最後に来る。高さ制限しない。すべてのメンバーを表示する
  // タブレット以上は高さ制限する。見切れる場合があるが十分な高さがあるので問題ない
  +tablet
    position: relative
    .scroll_block
      +overlay
      +is_scroll_y

.ShareBoardMemberList.column
  &.content_blank_p
    +mobile
      display: none

.ShareBoardApp.debug_mode_p
  .ShareBoardMemberList
    .scroll_block
      // border-radius: 3px
      // background-color: $white-ter
</style>
