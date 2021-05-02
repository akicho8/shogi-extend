<template lang="pug">
MainNavbar.ShareBoardNavbar(:spaced="false" :type="base.edit_mode_p ? 'is-dark' : 'is-primary'")
  template(slot="brand")
    b-navbar-item(@click.native="base.exit_handle")
      b-icon(icon="home")

    b-navbar-item.has-text-weight-bold.title_edit_navbar_item(@click="base.title_edit")
      | {{base.current_title || '？'}}
      span.mx-1(v-if="base.play_mode_p && base.turn_offset >= 1")
        | \#{{base.turn_offset}}
      span.mx-1(v-if="base.edit_mode_p")
        | (編集モード)

  template(slot="end")
    b-navbar-item.is-unselectable(tag="div" v-if="base.ac_room && development_p")
      b-icon(icon="account")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary {{base.member_infos.length}}

    b-navbar-item.px_5_if_tablet.is-unselectable.message_modal_handle(tag="a" @click="base.message_modal_handle" v-if="base.ac_room")
      b-icon.account_icon(icon="account")
      b-icon.message_icon(icon="chat-processing")

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="base.tweet_modal_handle" v-if="base.tweet_button_p")
      b-icon(icon="twitter" type="is-white")

    b-navbar-item.has-text-weight-bold(tag="div" v-if="base.edit_mode_p")
      .buttons
        .button.is-primary(@click="base.play_mode_handle")
          | 編集完了

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle" v-if="base.play_mode_p")
      b-icon(icon="menu")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardNavbar
  .message_modal_handle
    .icon
      position: relative
      &.account_icon
        top: 5px
        left: 3px
      &.message_icon
        top: -7px
        left: -3px
</style>
