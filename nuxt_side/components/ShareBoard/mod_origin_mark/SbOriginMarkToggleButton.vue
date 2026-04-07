<template lang="pug">
a.navbar_item.navbar_item_wide.SbOriginMarkToggleButton.origin_mark_toggle_button_click_handle(
  @click="SB.origin_mark_toggle_button_click_handle"
  v-if="SB.origin_mark_button_show_p"
  )
  .mdi.mdi-pencil
  .mdi.mdi-circle-outline(v-if="SB.origin_mark_mode_p")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbOriginMarkToggleButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbOriginMarkToggleButton
  font-size: 1.75rem
  .mdi
    position: absolute
  .mdi-circle-outline
    font-size: 3.0rem
</style>
