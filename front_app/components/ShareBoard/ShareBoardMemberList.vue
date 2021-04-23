<template lang="pug">
.ShareBoardMemberList.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in member_infos")
      .member_info.is_line_break_off.is-clickable.is-flex.is-align-items-center(:key="e.from_user_code" @click="row_click_handle(e)" :class="{is_zombie: !base.member_alive_p(e)}")
        span.left_tag_or_icon.is-inline-flex.is-justify-content-center.is-align-items-center
          template(v-if="order_lookup(e)")
            b-tag(:type="tag_type_for(e)" rounded) {{tag_body_for(e)}}
          template(v-else)
            b-icon(:icon="icon_for(e)" :type="icon_type_for(e)")
        span.ml-1(:class="{'has-text-weight-bold': turn_active_p(e)}") {{e.from_user_name}}
        span.ml-1.is-size-7.time_format.has-text-grey-light(v-if="development_p") {{time_format(e)}}
        span.ml-1(v-if="development_p") r{{e.revision}}
        span.ml-1(v-if="development_p") {{e.user_age}}歳
        span.ml-1(v-if="development_p") {{base.member_elapsed_second(e)}}秒前
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
      this.talk(`${this.base.user_call_name(e.from_user_name)}`)
    },
    time_format(v) {
      return dayjs.unix(v.performed_at).format("HH:mm:ss")
    },
    // 自分のターンか？
    turn_active_p(e) {
      if (this.base.order_func_p) {
        if (this.base.ordered_members) {
          return this.base.current_turn_user_name === e.from_user_name
        }
      }
    },
    // 自分のアイコン
    icon_for(e) {
      return "account"
    },
    // 自分のアイコンの色
    // 反応がなくなったら灰色になる
    icon_type_for(e) {
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
      if (this.base.current_turn_user_name === e.from_user_name) {
        return "is-primary"
      } else {
        return "is_inactive"
      }
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

    overflow-y: auto
    overflow-x: hidden

    border-radius: 3px
    background-color: $white-ter
    padding: 0

    .time_format
      vertical-align: middle
    .member_info
      &.is_zombie
        opacity: 0.3
      text-overflow: ellipsis
      padding: 0.3rem 0.5rem
      color: inherit
      &:hover
        background-color: $grey-lighter
    .left_tag_or_icon
      min-width: 2rem
      .tag
        // font-size: unset
        // height: unset
        // padding: 0 0.5rem
        &.is_inactive
          background-color: unset

.STAGE-development
  .ShareBoardMemberList
</style>
