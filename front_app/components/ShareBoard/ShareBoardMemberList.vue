<template lang="pug">
.ShareBoardMemberList.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in member_infos")
      .member_info.is_line_break_off.is-clickable.is-flex.is-align-items-center(:key="e.from_user_code" @click="row_click_handle(e)" :class="member_info_class(e)")
        .left_tag_or_icon.is-inline-flex.is-justify-content-center.is-align-items-center(v-if="order_lookup(e)")
          b-tag(rounded) {{tag_body_for(e)}}
        b-icon.account_icon(:icon="icon_for(e)" :type="icon_type_for(e)" size="is-small")
        //- b-icon(icon="sleep" type="is-danger" size="is-small")
        //- b-icon(icon="lan-disconnect" type="is-danger" size="is-small")
        .user_name {{e.from_user_name}}
        .mx-1(v-if="base.user_code === e.from_user_code") (自分)
        b-icon.mx-1(icon="lan-disconnect" type="is-danger" size="is-small" v-if="base.member_disconnect_p(e) || development_p")
        template(v-if="development_p")
          .mx-1 {{time_format(e)}}
          .mx-1 {{e.room_joined_at}}
          .mx-1 LV:{{e.active_level}}
          .mx-1 通知{{e.alive_notice_count}}回目
          .mx-1 {{base.member_elapsed_sec(e)}}秒前
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
      this.base.member_info_click_handle(e)
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
      // if (this.base.member_disconnect_p(e)) {
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
    icon_type_for(e) {
      if (this.base.member_disconnect_p(e)) {
        return "is-grey"
      }
      // if (!this.base.member_alive_p(e)) {
      //   return "is-grey"
      // }
      return "is-primary"
    },

    order_lookup(e) {
      if (this.base.order_func_p) {
        if (this.base.ordered_members) {
          return this.user_names_hash[e.from_user_name]
        }
      }
    },

    tag_body_for(e) {
      const found = this.order_lookup(e)
      return found.order_index + 1
    },

    // 自分のアイコンの色
    // 反応がなくなったら灰色になる
    tag_type_for(e) {
      // if (!this.base.member_alive_p(e)) {
      //   return "is-grey"
      // }
      // const found = this.order_lookup(e)
      // if (found) {
      // if (this.base.current_turn_user_name === e.from_user_name) {
      //   return "is_turn_active"
      // } else {
      //   return "is_turn_standby"
      // }
      // }
    },

    member_info_class(e) {
      return {
        is_joined:        !this.base.order_func_p,                                                       // 初期状態
        is_disconnect:    this.base.member_disconnect_p(e),                                              // 霊圧が消えかけ
        is_turn_active:   this.order_lookup(e) && this.base.current_turn_user_name === e.from_user_name, // 手番の人
        is_turn_standby: this.order_lookup(e) && this.base.current_turn_user_name !== e.from_user_name, // 手番待ちの人
        is_watching:      this.base.order_func_p && !this.order_lookup(e),                               // 観戦
        is_self:          this.base.user_code === e.from_user_code,                                      // 自分？
        is_window_blur:   e.window_active_count === 0,                                                   // Windowが非アクティブ状態か？
      }
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
              found = this.user_names_hash[e.from_user_name] // O(1)
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
    // 名前からO(1)で ordered_members の要素を引くためのハッシュ
    user_names_hash() {
      if (this.base.order_func_p) {
        if (this.base.ordered_members) {
          return this.base.ordered_members.reduce((a, e) => ({...a, [e.user_name]: e}), {})
        }
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.ShareBoardMemberList.column
  position: relative
  +tablet
    max-width: 8rem
  +desktop
    max-width: 12rem
  +widescreen
    max-width: 16rem
  +mobile
    height: 20rem

  .scroll_block
    @extend %overlay

    overflow: auto

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    .time_format
      vertical-align: middle
    .member_info
      line-height: 2.25
      // text-overflow: ellipsis
      // overflow-x: auto
      padding: 0 0.5rem
      color: inherit
      &:hover
        background-color: $grey-lighter
    .user_name
      margin: 0 0.25rem

    .left_tag_or_icon
      min-width: 1.75rem
      .tag
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

    .member_info
      &.is_window_blur
        opacity: 0.5
      &.is_disconnect
        opacity: 0.25
      &.is_self
      &.is_turn_standby
      &.is_turn_active
        font-weight: bold
        // .account_icon
        //   color: $warning
        .left_tag_or_icon
          .tag
            border: 2px solid $primary

.STAGE-development
  .ShareBoardMemberList
</style>
