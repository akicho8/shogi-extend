<template lang="pug">
MainNavbar.WkbkTopNavbar(:spaced="false")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold.px_0_if_mobile(tag="nuxt-link" :to="{name: 'rack'}")
      span.is-hidden-mobile
        | インスタント将棋問題集
      span.is-hidden-tablet
        | 問題集

  template(slot="start")
    b-navbar-item.is-hidden-touch.with_search_field(tag="div")
      WkbkTopSearch(:base="base")

  template(slot="end")
    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles-new'}" @click.native="sound_play_click()")
      b-icon(icon="plus")

    b-navbar-item.has-text-weight-bold.px_5_if_tablet(tag="nuxt-link" :to="{name: 'rack-articles'}" @click.native="sound_play_click()")
      b-icon(icon="table-cog")

    NavbarItemLogin
    NavbarItemProfileLink

    WkbkSidebarToggle(:base="base" @click="base.sidebar_toggle" v-if="false")

    //- b-navbar-item.is-hidden-desktop.has-text-weight-bold(@click="base.search_field_toggle_handle")
    //-   b-icon(icon="magnify")
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
