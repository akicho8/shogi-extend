<template lang="pug">
MainNavbar.WkbkBookIndexNavbar(:spaced="false")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'library-books'}") みんなの将棋問題集

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    b-navbar-item.has-text-weight-bold.px-5(tag="nuxt-link" :to="{name: 'library-books-new'}" @click.native="sound_play('click')")
      b-icon(icon="plus")

    b-navbar-item.px-5(@click="base.sidebar_toggle")
      b-icon(icon="menu")
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
