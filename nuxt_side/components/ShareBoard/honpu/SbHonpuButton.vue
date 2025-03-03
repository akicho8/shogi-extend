<template lang="pug">
b-navbar-item.SbHonpuButton.has-text-weight-bold(
  tag="div"
  v-if="SB.honpu_button_show_share_condition && (SB.honpu_jump_button_show_p || SB.honpu_return_button_show_p)"
  )
  .field.is-grouped
    p.control(v-if="SB.honpu_jump_button_show_p")
      a.button.honpu_jump_click_handle(@click="SB.honpu_jump_click_handle" :class="SB.appearance_theme_info.navibar_button_color")
        b-icon(icon="note")
    p.control(v-if="SB.honpu_return_button_show_p")
      a.button.honpu_return_click_handle(@click="SB.honpu_return_click_handle" :class="SB.appearance_theme_info.navibar_button_color")
        b-icon(icon="undo")








//- b-navbar-item.SbHonpuButton.has-text-weight-bold(
//-   tag="div"
//-   v-if="SB.honpu_button_show_share_condition && (SB.honpu_jump_button_show_p || SB.honpu_return_button_show_p)"
//-   )
//-   .buttons
//-     template(v-if="SB.honpu_jump_button_show_p")
//-       a.button.honpu_jump_click_handle(@click="SB.honpu_jump_click_handle" :class="SB.appearance_theme_info.navibar_button_color")
//-         b-icon(icon="note")
//-     template(v-if="SB.honpu_return_button_show_p")
//-       a.button.honpu_return_click_handle(@click="SB.honpu_return_click_handle" :class="SB.appearance_theme_info.navibar_button_color")
//-         b-icon(icon="undo")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbHonpuButton",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.SbHonpuButton
  __css_keep__: 0
</style>
