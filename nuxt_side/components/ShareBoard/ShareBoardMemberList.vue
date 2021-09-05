<template lang="pug">
.ShareBoardMemberList.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in member_infos")
      ShareBoardAvatarLine.member_one_line.is-clickable(:base="base" :info="e" :key="e.from_connection_id" @click="row_click_handle(e)" :class="base.member_info_class(e)")
        .flex_item.left_tag_or_icon(v-if="base.order_lookup(e)")
          b-tag(rounded) {{base.order_display_index(e)}}
        //- .icon_wrap(v-if="e.from_avatar_path == null")
        //-   b-icon.account_icon(:icon="icon_for(e)" size="is-small")
        //- b-icon(icon="sleep" type="is-danger" size="is-small")
        //- b-icon(icon="lan-disconnect" type="is-danger" size="is-small")
        //- .user_name {{e.from_user_name}}
        b-icon.flex_item(icon="arrow-left-bold" size="is-small" v-if="base.connection_id === e.from_connection_id")
        b-icon.flex_item(icon="lan-disconnect" type="is-danger" size="is-small" v-if="base.member_is_disconnect(e) || development_p")
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
      if (false) {
        this.base.member_info_ping_handle(e)
      } else {
        this.base.member_info_modal_handle(e)
      }
      // if (this.base.member_alive_p(e)) {
      //   this.talk(`${this.base.user_call_name(e.from_user_name)}は元気です`)
      // } else {
      //   this.talk(`${this.base.user_call_name(e.from_user_name)}の霊圧が……消えた……？`)
      // }
    },
    time_format(e) {
      return dayjs(e.performed_at).format("HH:mm:ss")
    },
    // 自分のターンか？
    turn_active_p(e) {
      if (this.base.order_func_p) {
        if (this.base.ordered_members) {
          return this.base.current_turn_user_name === e.from_user_name
        }
      }
    },
    icon_for(e) {
      // if (this.base.member_is_disconnect(e)) {
      //   return "account-off"
      // }
      // if (this.base.order_func_p) {
      // if (this.base.order_func_p) {
      //   return "account-outline" // 観戦中のアイコン
      // } else {
      //   return "account"         // 通常のアイコン
      // }
      return "account"         // 通常のアイコン
    },
    // 自分のアイコンの色
    // 反応がなくなったら灰色になる
    // icon_type_for(e) {
    //   // if (this.base.member_is_disconnect(e)) {
    //   //   return "is-grey"
    //   // }
    //   // // // if (!this.base.member_alive_p(e)) {
    //   // // //   return "is-grey"
    //   // // // }
    //   // return "is-primary"
    // },

    // 自分のアイコンの色
    // 反応がなくなったら灰色になる
    tag_type_for(e) {
      // if (!this.base.member_alive_p(e)) {
      //   return "is-grey"
      // }
      // const found = this.base.order_lookup(e)
      // if (found) {
      // if (this.base.current_turn_user_name === e.from_user_name) {
      //   return "is_turn_active"
      // } else {
      //   return "is_turn_standby"
      // }
      // }
    },

  },
  computed: {
    member_infos() {
      if (this.base.order_func_p) {
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
    overflow: auto
    padding: 0

    .time_format
      vertical-align: middle
    .ShareBoardAvatarLine
      line-height: 2.25
      // text-overflow: ellipsis
      // overflow-x: auto
      padding: 0.2rem 0rem
      color: inherit
      &:hover
        background-color: $white-ter

    // .user_name
    //   margin-left: 0.5rem
    //   margin-right: 0.25rem

    .left_tag_or_icon
      .tag
        // min-width: 1.75rem
        // margin-right: 0.25rem
        background-color: unset
        // font-size: unset
        // height: unset
        padding: 0 0.4rem
        // &.is_turn_active
        //   border: 2px solid $primary
        //   // background-color: $white
        //   background-color: unset
        // &.is_turn_standby
        //   background-color: unset
        //   // border: 2px solid change_color($primary, $alpha: 0.2)

    .account_icon
      width: 2rem
      height: 2rem
    .account_icon
      color: $primary

    .ShareBoardAvatarLine
      &.is_window_blur
        opacity: 0.5
      &.is_disconnect
        opacity: 0.25
        .account_icon
          color: unset
      &.is_self
      &.is_turn_standby
      &.is_turn_active
        font-weight: bold
        // .account_icon
        //   color: $warning
        .left_tag_or_icon
          .tag
            border: 2px solid $primary

.ShareBoardMemberList.column
  // モバイルのときは最後に来る。高さ制限しない。すべてのメンバーを表示する
  // タブレット以上は高さ制限する。見切れる場合があるが十分な高さがあるので問題ない
  +tablet
    position: relative
    max-width: 8rem
    .scroll_block
      +overlay
  +desktop
    max-width: 12rem
  +widescreen
    max-width: 16rem

.STAGE-development
  .ShareBoardMemberList
    .scroll_block
      // border-radius: 3px
      // background-color: $white-ter
</style>
