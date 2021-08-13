<template lang="pug">
b-sidebar.is-unselectable.XconvSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="対局")
          b-menu-item.is_active_unset(icon="home-account" label="部屋に入る")

      //- .style_container.box.mt-5
      //-   .title.is-5 スタイル設定
      //-   b-field(custom-class="is-small" label="盤の大きさ")
      //-     b-slider(v-bind="slider_attrs" v-model="" :min="0" :max="100" :step="1.0")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvSidebar",
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

.XconvSidebar
  .sidebar-content
    width: 20rem

  .menu-label
    margin-top: 2em

  .b-slider
    .b-slider-thumb-wrapper.has-indicator
      .b-slider-thumb
        padding: 8px 4px
        font-size: 10px

  .style_container
    +mobile
      display: none

  .user_account
    img
      max-height: none
      height: 32px
      width: 32px

  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem
</style>
