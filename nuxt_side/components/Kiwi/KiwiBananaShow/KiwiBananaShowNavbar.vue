<template lang="pug">
MainNavbar.KiwiBananaShowNavbar(:spaced="false" centered wrapper-class="container is-fluid px-0")
  template(slot="brand")
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sfx_play_click()")
      b-icon(icon="chevron-left")
  template(slot="end")
    b-navbar-item.px_5_if_tablet.switch_handle(@click="base.switch_handle" v-if="base.banana")
      b-icon(icon="hand-pointing-up")
    b-navbar-item.px_5_if_tablet(@click.native="sfx_play_click()" tag="nuxt-link" :to="{name: 'video-studio-banana_key-edit', params: {banana_key: base.banana.key}}" v-if="base.banana && base.owner_p && development_p")
      b-icon(icon="pencil")
    b-navbar-item.px_5_if_tablet(@click.native="sfx_play_click()" tag="nuxt-link" :to="{name: 'share-board', query: {...base.current_share_board_params, title: base.banana.title}}" v-if="base.banana")
      b-icon(icon="checkerboard")
    b-navbar-item.px_5_if_tablet(@click.native="base.download_handle" :href="base.banana.lemon.browser_path" :download="base.banana.lemon.filename_human" v-if="base.banana")
      b-icon(icon="download")
    b-navbar-item.px_5_if_tablet(@click="base.tweet_handle" v-if="base.banana")
      b-icon(icon="twitter")
    NavbarItemLogin
    NavbarItemProfileLink
    NavbarItemSidebarOpen(@click="base.sidebar_toggle" v-if="false")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBananaShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBananaShowNavbar
  __css_keep__: 0
</style>
