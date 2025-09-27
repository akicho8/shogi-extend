<template lang="pug">
MainNavbar.KiwiTopNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video'}")
      | 動画
      //- span.is-hidden-mobile
      //-   | ギャラリー
      //- span.is-hidden-tablet
      //-   | 動画集

  template(slot="start")
    b-navbar-item(tag="div")
      KiwiTopSearch(:base="base")

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-studio'}" @click.native="sfx_play_click()")
      b-icon(icon="table-cog")

    NavbarItemLogin
    NavbarItemProfileLink

    NavbarItemSidebarOpen(@click="base.sidebar_toggle" v-if="false")

    //- b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sfx_play_click()")
    //-   b-icon(icon="cog")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiTopNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiTopNavbar
  __css_keep__: 0
</style>
