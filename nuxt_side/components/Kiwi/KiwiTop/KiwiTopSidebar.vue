<template lang="pug">
b-sidebar.KiwiTopSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      NavbarItemSidebarClose(@click="base.sidebar_toggle")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          //- b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'video-new'}" label="動画集作成" @click.native="sfx_click()")
          b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'video'}" label="動画リスト" @click.native="sfx_click()")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiTopSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiTopSidebar
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em

</style>
