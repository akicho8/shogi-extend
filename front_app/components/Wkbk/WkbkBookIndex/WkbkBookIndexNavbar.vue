<template lang="pug">
MainNavbar.WkbkBookIndexNavbar(:spaced="false")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'library-books'}") みんなの将棋問題集

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
