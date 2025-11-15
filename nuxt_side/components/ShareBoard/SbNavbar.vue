<template lang="pug">
MainNavbar.SbNavbar(v-bind="component_attrs")
  template(slot="brand")
    template(v-if="SB.home_display_p")
      b-navbar-item(@click.native="SB.exit_handle" v-if="SB.home_display_p")
        b-icon(icon="home")

      b-navbar-item.has-text-weight-bold.title_navbar_item.is_truncate.is-hidden-mobile(@click="SB.title_edit_handle")
        template(v-if="SB.edit_mode_p")
          span 編集モード
        template(v-if="SB.play_mode_p")
          span
            | {{SB.current_title}}
          span.mx-1
            | \#{{SB.current_turn}}

    template(v-if="SB.give_up_button_show_p")
      b-navbar-item.has-text-weight-bold(tag="div")
        .buttons
          a.button.give_up_modal_open_handle(@click="SB.give_up_modal_open_handle" :class="SB.appearance_theme_info.toryo_button_color")
            | 投了

  template(slot="start")
    template(v-if="SB.debug_mode_p")
      b-navbar-item.is-hidden-mobile
        b-tag.has-text-weight-bold(rounded)
          .has-text-primary {{SB.perpetual_cop.count}}

      b-navbar-item.is-hidden-mobile(@click="SB.tl_modal_open_handle")
        b-tag(rounded)
          .has-text-primary {{SB.track_logs.length}}

      b-navbar-item.is-hidden-mobile(tag="div" v-if="SB.ac_room && development_p")
        b-icon(icon="account")
        b-tag(rounded)
          .has-text-primary {{SB.member_infos.length}}

    template(v-if="SB.otasuke_single_line")
      b-navbar-item.has-text-weight-bold.otasuke_single_line.is-hidden-mobile(tag="div" :class="SB.otasuke_single_line.css_class")
        | {{SB.otasuke_single_line.message}}

  template(slot="end")
    SbHonpuButton

    SbThinkMarkToggleButton

    template(v-if="SB.otasuke_button_show_p")
      b-navbar-item.is-hidden-mobile.has-text-weight-bold.px_5_if_tablet.otasuke_click_handle(@click="SB.otasuke_click_handle")
        b-icon(:icon="SB.otasuke_button_icon")

    template(v-if="SB.tweet_button_show_p")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet.tweet_modal_handle(@click="SB.tweet_modal_handle")
        b-icon(icon="twitter" type="is-white")

    template(v-if="SB.edit_mode_p")
      b-navbar-item.has-text-weight-bold(tag="div")
        .buttons
          a.button.is-primary(@click="SB.play_mode_set_handle")
            | 編集完了

    SbChatOpenButton2

    // テストで参照しているので sidebar_toggle_navbar_item は取ったらいけん
    template(v-if="SB.play_mode_p")
      NavbarItemSidebarOpen(@click="SB.sidebar_toggle_handle")
</template>

<script>
import { support_child } from "./support_child.js"
// import SbThinkMarkToggleButton from "./think_mark/SbThinkMarkToggleButton.vue"

export default {
  name: "SbNavbar",
  mixins: [support_child],
  computed: {
    component_attrs() {
      const hv = {}

      // hv.centered = true
      // hv.shadow = true

      // hv.transparent = true
      hv.type = this.SB.appearance_theme_info.navbar_type
      // hv["fixed-top"] = true
      // hv.fixedTop = true

      hv.spaced = false
      if (this.SB.edit_mode_p) {
        // hv.type = "is-dark"
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
@import "./sass/support.sass"
//////////////////////////////////////////////////////////////////////////////// __theme__

// .SbApp
//   &.is_appearance_theme_b
//     &.play_mode_p
//       .SbNavbar
//         &.is-primary
//           background-color: transparent
//           .navbar-item, .navbar-link
//             color: $grey

.SbNavbar
  .otasuke_single_line
    +mobile
      font-size: $size-7

  .otasuke_blink
    animation: otasuke_blink 1.0s ease-in-out 0s infinite alternate

  // background-color: transparent
  // +is_backdrop_filter(10px)

@keyframes otasuke_blink
  0%
    opacity: 1.0
  50%
    opacity: 0.6
  100%
    opacity: 1.0
</style>
