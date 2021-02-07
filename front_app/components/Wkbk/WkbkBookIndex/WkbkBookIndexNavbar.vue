<template lang="pug">
MainNavbar.WkbkBookIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    //- NavbarItemHome
    b-navbar-item(tag="nuxt-link" :to="{name: 'library'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    //- b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'library-books'}") みんなの将棋問題集
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'library-books'}") 問題集管理

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'library-books-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    WkbkSidebarToggle(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookIndexNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookIndexNavbar
</style>
