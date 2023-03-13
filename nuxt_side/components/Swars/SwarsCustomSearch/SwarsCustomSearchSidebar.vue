<template lang="pug">
b-sidebar.is-unselectable.SwarsCustomSearchSidebar(fullheight right overlay v-model="TheApp.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="TheApp.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(@click="TheApp.form_reset_handle" label="オプション類を外す")
          b-menu-item.is_active_unset(@click="TheApp.all_reset_handle"  label="完全リセット")
          b-menu-item.is_active_unset(@click="TheApp.parmalink_handle"  label="パーマリンク化")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.SwarsCustomSearchSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
.STAGE-development
  .SwarsCustomSearchSidebar
    ul, li
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
