<template lang="pug">
MainNavbar.KiwiBananaIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    //- NavbarItemHome
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sfx_play_click()")
      b-icon(icon="chevron-left")
    //- b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-studio'}") インスタント将棋動画
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-studio'}") 動画スタジオ

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-new'}" @click.native="sfx_play_click()")
      b-icon(icon="video-plus")

    NavbarItemLogin
    NavbarItemProfileLink

    NavbarItemSidebarOpen(@click="base.sidebar_toggle" v-if="false")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaIndexNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaIndexNavbar
  __css_keep__: 0
</style>
