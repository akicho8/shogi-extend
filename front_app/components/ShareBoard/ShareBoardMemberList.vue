<template lang="pug">
.ShareBoardMemberList.column
  .scroll_block(ref="scroll_block")
    template(v-for="(e, i) in member_infos")
      .member_info.is_line_break_off.is-clickable(:key="e.from_user_code" @click="member_info_click_handle(e)")
        b-icon(icon="account" size="is-small" :type="member_icon_type(e)")
        span.ml-1 {{e.from_user_name}}
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
    member_icon_type(e) {
      return this.base.member_active_p(e) ? "is-primary" : "is-grey"
    },
    member_info_click_handle(e) {
      this.talk(`${this.base.user_call_name(e.from_user_name)}`)
    },
    time_format(v) {
      return dayjs.unix(v.performed_at).format("HH:mm:ss")
    },
  },
  computed: {
    member_infos() {
      // return _.reverse(this.base.member_infos.slice())
      return this.base.member_infos
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
      text-overflow: ellipsis
      padding: 0.2rem 0.5rem
      color: inherit
      &:hover
        background-color: $grey-lighter

.STAGE-development
  .ShareBoardMemberList
</style>
