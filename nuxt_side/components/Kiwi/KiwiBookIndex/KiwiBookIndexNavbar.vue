<template lang="pug">
MainNavbar.KiwiBookIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    //- NavbarItemHome
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    //- b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-books'}") インスタント将棋動画
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'video-books'}") 動画リスト

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video-books-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    KiwiSidebarToggle.is-hidden-desktop(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookIndexNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiBookIndexNavbar
</style>
