<template lang="pug">
MainNavbar.SbNavbar(v-bind="component_attrs")
  template(slot="brand")
    template(v-if="SB.home_display_p")
      b-navbar-item(@click.native="SB.exit_handle" v-if="SB.home_display_p")
        b-icon(icon="home")

      b-navbar-item.has-text-weight-bold.title_navbar_item(@click="SB.title_edit_handle")
        template(v-if="SB.edit_mode_p")
          span.current_title.is_truncate.is-hidden-mobile
            span 編集モード
        template(v-if="SB.play_mode_p")
          span.current_title.is_truncate.is-hidden-mobile
            | {{SB.current_title}}
          span.mx-1
            | \#{{SB.current_turn}}

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.give_up_modal_open(@click="SB.give_up_modal_open" v-if="SB.give_up_button_show_p")
      | 投了

  template(slot="start")
    template(v-if="SB.debug_mode_p")
      b-navbar-item.px_5_if_tablet.is-unselectable.has-text-weight-bold
        b-tag.has-text-weight-bold(rounded)
          .has-text-primary
            | {{SB.perpetual_cop.count}}

      b-navbar-item.px_5_if_tablet.is-unselectable.has-text-weight-bold(@click="SB.tl_modal_handle")
        b-tag.has-text-weight-bold(rounded)
          .has-text-primary
            | {{SB.track_logs.length}}

      b-navbar-item.is-unselectable(tag="div" v-if="SB.ac_room && development_p")
        b-icon(icon="account")
        b-tag.has-text-weight-bold(rounded)
          .has-text-primary {{SB.member_infos.length}}

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet.otasuke_click_handle(@click="SB.otasuke_click_handle" v-if="SB.otasuke_button_show_p")
      b-icon(:icon="SB.otasuke_button_icon")

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.tweet_modal_handle(@click="SB.tweet_modal_handle" v-if="SB.tweet_button_show_p")
      b-icon(icon="twitter" type="is-white")

    b-navbar-item.has-text-weight-bold(tag="div" v-if="SB.edit_mode_p")
      .buttons
        .button.is-primary(@click="SB.play_mode_handle")
          | 編集完了

    b-navbar-item.has-text-weight-bold.px_5_if_tablet.honpu_log_click_handle(@click="SB.honpu_log_click_handle" v-if="SB.honpu_button_show_p")
      | 本譜

    b-navbar-item.px_5_if_tablet.is-unselectable.chat_modal_open_handle(tag="a" @click="SB.chat_modal_open_handle" v-if="SB.ac_room || true")
      b-icon.account_icon(icon="account")
      b-icon.message_icon(icon="chat-processing")

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    NavbarItemSidebarOpen(@click="SB.sidebar_toggle" v-if="SB.play_mode_p")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbNavbar",
  mixins: [support_child],
  computed: {
    component_attrs() {
      const hv = {}

      // hv.transparent = true
      hv.type = this.SB.appearance_theme_info.navbar_type

      hv.spaced = false
      if (this.SB.edit_mode_p) {
        hv.type = "is-dark"
      } else {
        if (this.SB.order_enable_p) {
          // hv.transparent = true
          // hv.type = ""
        } else {
        }
        // hv.type = "is-primary"
        // hv.type = "is-primary"
        if (this.SB.AppConfig.NAVBAR_COLOR_CHANGE) {
          if (this.SB.clock_box) {
            if (this.SB.clock_box.play_p) {
              const rest = this.SB.clock_box.current.rest
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
  .chat_modal_open_handle
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
