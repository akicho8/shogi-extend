<template lang="pug">
.XclockAppFooter.is-flex
  .item(@click="app.back_handle")
    b-icon(icon="arrow-left")

  b-dropdown(position="is-top-left" @active-change="e => app.dropdown_active_change(e)" ref="preset_menu_pull_down")
    .item(slot="trigger")
      b-icon(icon="menu")
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*10, initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 10分
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*3,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 3分
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 0,     initial_read_sec:10, initial_extra_sec: 0,  every_plus:0})") 将棋ウォーズ 10秒
    b-dropdown-item(:separator="true")
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋クエスト 5分
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*2,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0})") 将棋クエスト 2分
    b-dropdown-item(:separator="true")
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:5})") ABEMA フィッシャールール 5分 +5秒/手
    b-dropdown-item(:separator="true")
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*1,  initial_read_sec:30, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 早指  1分切ると1手30秒
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 0,     initial_read_sec:30, initial_extra_sec: 60, every_plus:0})") 将棋倶楽部24 早指2 1手30秒 猶予1分
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*15, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 15分  切ると1手60秒
    b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*30, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0})") 将棋倶楽部24 長考  30分切ると1手60秒
    template(v-if="development_p")
      b-dropdown-item(:separator="true")
      b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0})") 1行 7文字
      b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*30,   initial_read_sec:0,  initial_extra_sec:  0,  every_plus: 0})") 1行 5文字
      b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*60*2, initial_read_sec:0,  initial_extra_sec: 60,  every_plus: 0})") 2行 7文字
      b-dropdown-item(@click="app.rule_set({initial_main_sec: 60*60*2, initial_read_sec:60, initial_extra_sec: 60,  every_plus:60})") 3行 7文字

  .item(@click="app.play_handle")
    b-icon(icon="play")

  .item(@click="app.copy_handle")
    b-icon(icon="content-duplicate")

  .item(@click="app.keyboard_handle")
    b-icon(icon="keyboard")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "XclockAppFooter",
  mixins: [
    support,
  ],
}
</script>

<style lang="sass">
@import "support.sass"
.XclockAppFooter
  z-index: 1

  @media (orientation: landscape)
    height: 48px
  @media (orientation: portrait)
    height: 64px
  +desktop
    height: 64px

  width: 100%

  padding: 0 8px

  justify-content: space-between
  align-items: center

  .dropdown, .dropdown-trigger
    height: 100%

  +desktop
    justify-content: center
    .button, .item
      margin-left: 5rem
      margin-right: 5rem

  border-top: 1px solid $grey-lighter
  background-color: change_color($white-ter, $alpha: 0.96)

  .item
    cursor: pointer

    padding-right: 1rem
    padding-left: 1rem
    height: inherit

    display: flex
    justify-content: center
    align-items: center
</style>
