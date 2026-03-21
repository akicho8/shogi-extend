<template lang="pug">
b-navbar-item.SbHonpuButton.has-text-weight-bold(
  tag="div"
  v-if="SB.honpu_button_show_share_condition && (SB.honpu_open_button_show_p || SB.honpu_return_button_active_p)"
  )
  .field.is-grouped
    p.control
      a.button.honpu_modal_open_handle(@click="SB.honpu_modal_open_handle" :class="SB.appearance_theme_info.honpu_button_color") 本譜
    p.control
      a.button.honpu_direct_return_handle(@click="SB.honpu_direct_return_handle" :class="SB.appearance_theme_info.undo_button_color" :disabled="!SB.honpu_return_button_active_p")
        b-icon(icon="undo")
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
