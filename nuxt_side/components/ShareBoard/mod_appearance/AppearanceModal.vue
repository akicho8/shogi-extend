<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | スタイル設定
  .modal-card-body
    //- .ui_parts
    SimpleRadioButton(:base="SB" model_name="AppearanceThemeInfo" var_name="appearance_theme_key" custom-class="is-small" element_size="is-small")
    SimpleSlider.is-hidden-touch(:base="SB" label="盤の大きさ" var_name="sb_board_width" :min="0" :max="100" :step="1.0")

    SimpleSlider(:base="SB" label="グリッドの太さ" var_name="sb_grid_stroke" :min="0" :max="3" :step="0.5" v-if="SB.debug_mode_p && false")

    SimpleRadioButton.is-hidden-mobile(:base="SB" model_name="DesktopLayoutInfo" var_name="desktop_layout_key" custom-class="is-small" element_size="is-small")

    // もともと .is-hidden-tablet を入れてスマホでのみ表示していたがやめた。
    // PC利用者は比較的リテラシーが高く、スマホで画面が見切れている人にいろいろアドバイスしたりしている人もいた。
    // だからPC利用者にこそこの設定が存在することを知ってもらうようにする。
    SimpleRadioButton.is-hidden-tablet(:base="SB" model_name="MobileLayoutInfo" var_name="mobile_layout_key" custom-class="is-small" element_size="is-small")

  .modal-card-foot
    b-button.appearance_modal_close_handle.has-text-weight-normal(@click="SB.appearance_modal_close_handle" icon-left="chevron-left")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "AppearanceModal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../sass/support"
.AppearanceModal
  __css_keep__: 0
  .modal-card-body
    display: flex
    flex-direction: column
    gap: 0.5rem
</style>
