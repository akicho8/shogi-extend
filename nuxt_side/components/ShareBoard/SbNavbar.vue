<template lang="pug">
MainNavbar.SbNavbar(v-bind="component_attrs")
  template(slot="brand")
    b-navbar-item(@click.native="TheSb.exit_handle" v-if="TheSb.home_display_p")
      b-icon(icon="home")

    b-navbar-item.has-text-weight-bold.title_navbar_item(@click="TheSb.title_edit_handle")
      template(v-if="TheSb.edit_mode_p")
        span.current_title.is_truncate.is-hidden-mobile
          span 編集モード
      template(v-if="TheSb.play_mode_p")
        span.current_title.is_truncate.is-hidden-mobile
          | {{TheSb.current_title}}
        span.mx-1
          | \#{{TheSb.current_turn}}

  template(slot="end")
    b-navbar-item.px_5_if_tablet.is-unselectable.has-text-weight-bold(@click="TheSb.tl_modal_handle" v-if="TheSb.debug_mode_p")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary
          | {{TheSb.track_logs.length}}

    b-navbar-item.is-unselectable(tag="div" v-if="TheSb.ac_room && development_p && TheSb.debug_mode_p")
      b-icon(icon="account")
      b-tag.has-text-weight-bold(rounded)
        .has-text-primary {{TheSb.member_infos.length}}

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.tweet_modal_handle(@click="TheSb.tweet_modal_handle" v-if="TheSb.tweet_button_show_p")
      b-icon(icon="twitter" type="is-white")

    b-navbar-item.px_5_if_tablet.is-unselectable.message_modal_handle(tag="a" @click="TheSb.message_modal_handle" v-if="TheSb.ac_room || true")
      b-icon.account_icon(icon="account")
      b-icon.message_icon(icon="chat-processing")

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.honpu_log_click_handle(@click="TheSb.honpu_log_click_handle" v-if="TheSb.honpu_button_show_p")
      | 本譜

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.toryo_confirm_handle(@click="TheSb.toryo_confirm_handle" v-if="TheSb.toryo_button_show_p")
      | 投了

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.otasuke_click_handle(@click="TheSb.otasuke_click_handle" v-if="TheSb.otasuke_button_show_p")
      b-icon(:icon="TheSb.otasuke_button_icon")

    b-navbar-item.has-text-weight-bold(tag="div" v-if="TheSb.edit_mode_p")
      .buttons
        .button.is-primary(@click="TheSb.play_mode_handle")
          | 編集完了

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    NavbarItemSidebarOpen(@click="TheSb.sidebar_toggle" v-if="TheSb.play_mode_p")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbNavbar",
  mixins: [support_child],
  inject: ["TheSb"],
  computed: {
    component_attrs() {
      const hv = {}

      // hv.transparent = true
      hv.type = this.TheSb.appearance_theme_info.navbar_type

      hv.spaced = false
      if (this.TheSb.edit_mode_p) {
        hv.type = "is-dark"
      } else {
        if (this.TheSb.order_enable_p) {
          // hv.transparent = true
          // hv.type = ""
        } else {
        }
        // hv.type = "is-primary"
        // hv.type = "is-primary"
        if (this.TheSb.AppConfig.NAVBAR_COLOR_CHANGE) {
          if (this.TheSb.clock_box) {
            if (this.TheSb.clock_box.play_p) {
              const rest = this.TheSb.clock_box.current.rest
              if (rest <= 10) {
                hv.type = "is-danger"
              } else if (rest <= 20) {
                hv.type = "is-warning"
              }
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
.SbNavbar
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

// .SbApp
//   &.is_appearance_theme_b
//     &.normal_mode_p
//       .SbNavbar
//         &.is-primary
//           background-color: transparent
//           .navbar-item, .navbar-link
//             color: $grey
</style>
