<template lang="pug">
MainNavbar.KiwiBookIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    //- NavbarItemHome
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    //- b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-studio'}") インスタント将棋動画
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-studio'}") 動画管理

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-new'}" @click.native="sound_play('click')")
      b-icon(icon="video-plus")

    NavbarItemLogin
    NavbarItemProfileLink

    b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle" v-if="false")
      b-icon(icon="menu")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookIndexNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookIndexNavbar
</style>
