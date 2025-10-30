<template lang="pug">
.SbBottomNav(v-if="SB.debug_mode_p")
  .buttons_container
    a.button.is-marginless.is-small.is-primary.gate_modal_open_handle(@click="SB.gate_modal_open_handle") 入退室
    a.button.is-marginless.is-small.is-primary.os_modal_open_handle(@click="SB.os_modal_open_handle") 順番設定
    a.button.is-marginless.is-small.is-primary.cc_modal_open_handle(@click="SB.cc_modal_open_handle") 対局時計
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbBottomNav",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./sass/support.sass"
.SbBottomNav
  z-index: 30                   // b-navbar で fixed-bottom したときの初期値
  position: fixed
  bottom: 0
  left: 0
  right: 0
  // background-color: $black-ter
  +is_backdrop_filter(10px)
  .buttons_container
    display: flex
    align-items: center
    justify-content: center
    flex-wrap: nowrap
    overflow-x: auto
    gap: 0.25rem
    padding: 0.25rem
</style>
