<template lang="pug">
.AppearanceUi.box
  .title.is-6 スタイル設定
  .ui_parts
    SimpleRadioButton(:base="SB" model_name="AppearanceThemeInfo" var_name="appearance_theme_key" custom-class="is-small" element_size="is-small")
    SimpleSlider.is-hidden-touch(:base="SB" label="盤の大きさ" var_name="sb_board_width" :min="0" :max="100" :step="1.0")
    SimpleSlider(:base="SB" label="グリッドの太さ" var_name="sb_grid_stroke" :min="0" :max="3" :step="0.5" v-if="SB.debug_mode_p")
    SimpleRadioButton.is-hidden-tablet(:base="SB" model_name="MobileVerticalInfo" var_name="mobile_vertical_key" custom-class="is-small" element_size="is-small")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "AppearanceUi",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.AppearanceUi
  __css_keep__: 0
  .ui_parts
    display: flex
    flex-direction: column
    gap: 0.75rem
</style>

