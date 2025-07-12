<template lang="pug">
b-navbar-item.SbHonpuButton.has-text-weight-bold(
  tag="div"
  v-if="SB.honpu_button_show_share_condition && (SB.honpu_open_button_show_p || SB.honpu_return_button_show_p)"
  )
  .field.is-grouped
    p.control(v-if="SB.honpu_return_button_show_p")
      a.button.honpu_return_button(@click="SB.honpu_return_click_handle" :class="SB.appearance_theme_info.undo_button_color")
        b-icon(icon="undo")
    p.control(v-if="SB.honpu_open_button_show_p")
      a.button.honpu_open_button(@click="SB.honpu_open_click_handle" :class="SB.appearance_theme_info.toryo_button_color")
        | 本譜
        //- b-icon(icon="note")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbHonpuButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbHonpuButton
  __css_keep__: 0
  .button
    width: 4em
</style>
