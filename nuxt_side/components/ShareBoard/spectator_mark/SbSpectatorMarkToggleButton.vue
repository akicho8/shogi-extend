<template lang="pug">
b-navbar-item.SbSpectatorMarkToggleButton.has-text-weight-bold.px_5_if_tablet.spectator_mark_toggle_button_click_handle(
  @click="SB.spectator_mark_toggle_button_click_handle"
  v-if="SB.spectator_mark_button_show_p"
  )
  .icon_container
    b-icon.icon_pencil(:icon="SB.spectator_mark_button_icon" type="is-white")
    b-icon.icon_circle(icon="circle-outline" type="is-white" v-if="SB.mark_mode_p")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbSpectatorMarkToggleButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbSpectatorMarkToggleButton
  border: 1px solid red
  .icon_container
    width: 2rem                 // モバイル時にめっちゃ細くなって押せなくなるのを防ぐため
    position: relative
    display: flex
    justify-content: center
    align-items: center
    .icon
      line-height: 1.0          // 見えない何かが navbar の外まではみ出ているのを取るため
      position: absolute
      &.icon_circle
        .mdi:before
          font-size: 300%
</style>
