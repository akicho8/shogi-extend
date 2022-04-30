<template lang="pug">
b-sidebar.is-unselectable.SwarsCustomSearchSidebar(fullheight right overlay v-model="base.sidebar_p" v-if="base.xi")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          b-menu-item.is_active_unset(@click="base.form_reset_handle1" label="簡易リセット")
          b-menu-item.is_active_unset(@click="base.form_reset_handle2" label="完全リセット")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsCustomSearchSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsCustomSearchSidebar
  .menu-label:not(:first-child)
    margin-top: 2em
.STAGE-development
  .SwarsCustomSearchSidebar
    ul, li
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
