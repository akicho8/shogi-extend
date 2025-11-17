<template lang="pug">
b-sidebar.is-unselectable.XyMasterSidebar(fullheight right overlay v-model="TheApp.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="TheApp.sidebar_toggle")
    .mt-4
      .box
        .title.is-5 スタイル

        b-field.is-hidden-desktop.mb-0(custom-class="is-small" label="横幅 (Touch端末のみ)")
          b-slider(v-bind="slider_attrs" v-model="TheApp.touch_board_width" :min="0" :max="1" :step="0.001")

        b-field(custom-class="is-small" label="グリッドの太さ" v-if="development_p")
          b-slider(v-bind="slider_attrs" v-model="TheApp.xy_grid_stroke" :min="0.5" :max="2" :step="0.5")

        b-field(custom-class="is-small" label="グリッドの濃さ")
          b-slider(v-bind="slider_attrs" v-model="TheApp.xy_grid_color" :min="-20" :max="+20" :step="0.1")

        b-field(custom-class="is-small" label="星の大きさ")
          b-slider(v-bind="slider_attrs" v-model="TheApp.xy_grid_star_size" :min="0" :max="200" :step="0.1")

        hr

        SimpleRadioButton(:base="TheApp" model_name="GhostPresetInfo" var_name="ghost_preset_key" custom-class="is-small")

        b-field(custom-class="is-small" label="ゴーストの濃さ")
          b-slider(v-bind="slider_attrs" v-model="TheApp.xy_piece_opacity" :min="0" :max="1.0" :step="0.001")

        hr

        b-button.style_default_handle(@click="TheApp.style_default_handle" size="is-small") 初期値に戻す

      .box(v-if="development_p")
        .title.is-5 操作感
        SimpleRadioButton.x-field_block(:base="TheApp" model_name="TapDetectInfo" var_name="tap_detect_key")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterSidebar",
  mixins: [support_child],
  computed: {
    slider_attrs() {
      return {
        indicator: true,
        tooltip: false,
        size: "is-small",
      }
    },
  },
}
</script>

<style lang="sass">
@import "./support.sass"

.XyMasterSidebar
  .sidebar-content
    width: 20rem

  .menu-label
    margin-top: 2em

  .field:not(:first-child)
    margin-top: 1.75rem

  .style_default_handle
    // margin-top: 2rem

  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px
</style>
