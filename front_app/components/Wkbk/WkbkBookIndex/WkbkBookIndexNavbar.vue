<template lang="pug">
MainNavbar.WkbkBookIndexNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
  template(slot="brand")
    //- NavbarItemHome
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
    //- b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'rack-books'}") 将棋問題集
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'rack-books'}") 問題集リスト

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-books-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    WkbkSidebarToggle.is-hidden-desktop(@click="base.sidebar_toggle")
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
