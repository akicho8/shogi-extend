<template lang="pug">
b-sidebar.GalleryTopSidebar.is-unselectable(fullheight right overlay v-model="base.sidebar_p")
  .mx-4.my-4
    .is-flex.is-justify-content-start.is-align-items-center
      b-button.px-5(@click="base.sidebar_toggle" icon-left="menu")
    .mt-4
      b-menu
        b-menu-list(label="Action")
          //- b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'video-new'}" label="動画集作成" @click.native="sound_play('click')")
          b-menu-item.is_active_unset(tag="nuxt-link" :to="{name: 'video'}" label="動画リスト" @click.native="sound_play('click')")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryTopSidebar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.GalleryTopSidebar
  .dropdown-menu
    min-width: 0
    a:focus
      outline: none
  .menu-label:not(:first-child)
    margin-top: 2em

</style>
