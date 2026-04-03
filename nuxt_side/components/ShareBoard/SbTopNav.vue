<template lang="pug">
.SbTopNav
  .navbar_item_list.left
    a.navbar_item.navbar_item_wide.resign_confirm_modal_open_handle(@click="SB.resign_confirm_modal_open_handle" v-if="SB.resign_can_p")
      | 投了

    a.navbar_item.navbar_item_small.navbar_item_home(@click="SB.exit_handle" v-if="SB.home_display_p")
      b-icon(icon="home")

    a.navbar_item.navbar_item_small.navbar_item_title.is_truncate.is-hidden-mobile(@click="SB.title_edit_handle" v-if="SB.home_display_p")
      | {{SB.current_title}}

    a.navbar_item.navbar_item_small.is-hidden-mobile(@click="SB.tl_modal_open_handle" v-if="SB.debug_mode_p")
      | L{{SB.track_logs.length}}

    .navbar_item.navbar_item_small.is-hidden-mobile(v-if="SB.cable_p && SB.debug_mode_p")
      i.mdi.mdi-account
      | {{SB.member_infos.length}}

    .navbar_item.navbar_item_wide.xstatus_name.is-hidden-mobile(v-if="SB.xstatus_name")
      | {{SB.xstatus_name}}

  .navbar_item_list.right
    a.navbar_item.navbar_item_wide.honpu_button.honpu_modal_open_handle(v-if="SB.honpu_open_button_show_p" @click="SB.honpu_modal_open_handle")
      | 本譜
    a.navbar_item.navbar_item_wide.honpu_button.honpu_return_button_active_p(v-if="SB.honpu_return_button_active_p" @click="SB.honpu_direct_return_handle")
      .mdi.mdi-undo.is-size-3

    SbThinkMarkToggleButton

    a.navbar_item.navbar_item_wide.tweet_modal_handle(@click="SB.tweet_modal_handle" v-if="SB.tweet_button_show_p")
      .mdi.mdi-twitter

    a.navbar_item.navbar_item_wide.play_mode_set_handle(@click="SB.play_mode_set_handle" v-if="SB.edit_mode_p")
      | 編集完了

    SbChatOpenButton2

    a.navbar_item.navbar_item_wide.sidebar_toggle_handle(@click="SB.sidebar_toggle_handle" v-if="SB.play_mode_p")
      .mdi.mdi-menu
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbTopNav",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./sass/support.sass"
//////////////////////////////////////////////////////////////////////////////// __theme__

.SbTopNav
  display: flex
  justify-content: space-between // 2つの navbar_item_list を左右に振る
  height: 4rem

  .navbar_item_list
    display: flex
  .navbar_item
    display: flex
    align-items: center          // テキストだけなら不要だが .button などを入れる場合、軸中央に揃えるにはやっぱりこれがいる
    justify-content: center
    line-height: 1.0
    user-select: none
    font-weight: bold

  //////////////////////////////////////////////////////////////////////////////// 横幅

  .navbar_item
    &.navbar_item_small
      +mobile
        padding-inline: 0.5rem
      +tablet
        padding-inline: 1.0rem

  .navbar_item
    &.navbar_item_wide
      +mobile
        min-width: 4rem
      +tablet
        min-width: 5rem
      +desktop
        min-width: 8rem
      +widescreen
        min-width: 9rem
      +fullhd
        min-width: 10rem

  //////////////////////////////////////////////////////////////////////////////// 色
  background-color: $black
  .navbar_item
    color: $white
  a.navbar_item:hover
    background-color: $black-ter

  //////////////////////////////////////////////////////////////////////////////// 個々の調整
  .sidebar_toggle_handle
    font-size: 2rem
  .tweet_modal_handle
    font-size: 1.5rem

.STAGE-development
  .SbTopNav
    .navbar_item
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .navbar_item > *
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
