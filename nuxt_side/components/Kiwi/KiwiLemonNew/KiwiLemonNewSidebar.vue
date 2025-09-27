<template lang="pug">
b-sidebar.is-unselectable.KiwiLemonNewSidebar(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-space-between.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(icon="undo-variant" label="フォームを初期値に戻す" @click="base.pc_data_reset_handle")
          //- b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'video-studio'}" label="ライブラリ" @click.native="sfx_play_click()")

        b-menu-list(label="その他")
          b-menu-item.is_active_unset(icon="help-circle-outline" label="使い方" @click="base.general_help_modal_handle")

      //- .style_container.box.mt-5
      //-   .title.is-5 スタイル設定
      //-   b-field(custom-class="is-small" label="盤の大きさ")
      //-     b-slider(v-bind="slider_attrs" v-model="" :min="0" :max="100" :step="1.0")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewSidebar",
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
@import "./all_support.sass"

.KiwiLemonNewSidebar
  .sidebar-content
    width: 20rem

  .menu-label
    margin-top: 2em

  // .b-slider
  //   .b-slider-thumb-wrapper.has-indicator
  //     .b-slider-thumb
  //       padding: 8px 4px
  //       font-size: 10px

  // .style_container
  //   +mobile
  //     display: none
  //
  // .user_account
  //   img
  //     max-height: none
  //     height: 32px
  //     width: 32px

  .menu-list
    .icon
      color: $primary
      margin-right: 0.5rem
</style>
