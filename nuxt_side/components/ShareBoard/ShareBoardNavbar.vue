<template lang="pug">
MainNavbar.ShareBoardNavbar(v-bind="component_attrs")
  template(slot="brand")
    b-navbar-item(@click.native="base.exit_handle")
      b-icon(icon="home")

    b-navbar-item.has-text-weight-bold.title_edit_navbar_item(@click="base.title_edit_handle")
      span.current_title.is_truncate
        template(v-if="base.edit_mode_p")
          span 編集モード
        template(v-else)
          | {{base.current_title || '？'}}
          span.mx-1(v-if="base.play_mode_p && (base.current_turn >= 1 || development_p)")
            | \#{{base.current_turn}}

  template(slot="end")
    b-navbar-item.px_5_if_tablet.is-unselectable.has-text-weight-bold(@click="base.tl_modal_handle" v-if="base.debug_mode_p")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary
          | {{base.track_logs.length}}

    b-navbar-item.is-unselectable(tag="div" v-if="base.ac_room && development_p")
      b-icon(icon="account")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary {{base.member_infos.length}}

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.tweet_modal_handle(@click="base.tweet_modal_handle" v-if="base.tweet_button_show_p")
      b-icon(icon="twitter" type="is-white")

    b-navbar-item.px_5_if_tablet.is-unselectable.message_modal_handle(tag="a" @click="base.message_modal_handle" v-if="base.ac_room")
      b-icon.account_icon(icon="account")
      b-icon.message_icon(icon="chat-processing")

    b-navbar-item.has-text-weight-bold(tag="div" v-if="base.edit_mode_p")
      .buttons
        .button.is-primary(@click="base.play_mode_handle")
          | 編集完了

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    NavbarItemSidebarOpen(@click="base.sidebar_toggle" v-if="base.play_mode_p")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ShareBoardNavbar",
  mixins: [support_child],
  computed: {
    component_attrs() {
      const hv = {}

      // hv.transparent = true
      hv.type = this.base.appearance_theme_info.navbar_type

      hv.spaced = false
      if (this.base.edit_mode_p) {
        hv.type = "is-dark"
      } else {
        if (this.base.order_enable_p) {
          // hv.transparent = true
          // hv.type = ""
        } else {
        }
        // hv.type = "is-primary"
        // hv.type = "is-primary"
        if (this.base.clock_box) {
          if (this.base.clock_box.working_p) {
            const rest = this.base.clock_box.current.rest
            if (rest <= 10) {
              hv.type = "is-danger"
            } else if (rest <= 20) {
              hv.type = "is-warning"
            }
          }
        }
      }
      return hv
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"
.ShareBoardNavbar
  .current_title
    +mobile
      width: 12rem
      display: inline-block

  // チャットアイコンは2つをずらして組み合わせる
  .message_modal_handle
    .icon
      position: relative
      &.account_icon
        top: 5px
        left: 3px
      &.message_icon
        top: -7px
        left: -3px

//////////////////////////////////////////////////////////////////////////////// __theme__

// .ShareBoardApp
//   &.is_appearance_theme_b
//     &.normal_mode_p
//       .ShareBoardNavbar
//         &.is-primary
//           background-color: transparent
//           .navbar-item, .navbar-link
//             color: $grey
</style>
