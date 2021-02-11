<template lang="pug">
MainNavbar.WkbkTopNavbar(:spaced="false")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'rack'}") 将棋問題集

  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink

    //- b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-books-new'}" @click.native="sound_play('click')")
    //-   b-icon(icon="plus")

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles'}" @click.native="sound_play('click')")
      b-icon(icon="cog")

    WkbkSidebarToggle(@click="base.sidebar_toggle" v-if="false")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkTopNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopNavbar
</style>
