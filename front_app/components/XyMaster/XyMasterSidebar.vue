<template lang="pug">
b-sidebar.is-unselectable.XyMasterSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      //- b-menu
      //-   b-menu-list(label="リアルタイム共有")
      //-     b-menu-item.is_active_unset(label="部屋に入る"            @click="base.room_setup_modal_handle")
      //-     b-menu-item.is_active_unset(label="順番設定"              @click="base.os_modal_handle" :disabled="blank_p(base.ac_room)")
      //-     b-menu-item.is_active_unset(label="対局時計"              @click="base.cc_modal_handle")
      .box
        .title.is-5 スタイル設定

        b-field.is-hidden-desktop.mb-0(custom-class="is-small" label="横幅 (Touch端末のみ)")
          b-slider(v-bind="slider_attrs" v-model="base.touch_board_width" :min="0" :max="1" :step="0.001")

        b-field(custom-class="is-small" label="グリッドの太さ" v-if="development_p")
          b-slider(v-bind="slider_attrs" v-model="base.xy_grid_stroke" :min="0.5" :max="2" :step="0.5")

        b-field(custom-class="is-small" label="グリッドの濃さ")
          b-slider(v-bind="slider_attrs" v-model="base.xy_grid_color" :min="-20" :max="+10" :step="0.1")

        b-field(custom-class="is-small" label="星の大きさ")
          b-slider(v-bind="slider_attrs" v-model="base.xy_grid_star_size" :min="0" :max="100" :step="0.1")

        b-button.style_default_handle(@click="base.style_default_handle" size="is-small") デフォルトに戻す
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
    margin-top: 2rem

  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px
</style>
