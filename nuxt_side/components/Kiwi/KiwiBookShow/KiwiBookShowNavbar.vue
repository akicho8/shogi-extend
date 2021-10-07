<template lang="pug">
MainNavbar.KiwiBookShowNavbar(:spaced="false" centered wrapper-class="container is-fluid px-0")
  template(slot="brand")
    b-navbar-item.px_5_if_tablet(tag="nuxt-link" :to="{name: 'video'}" @click.native="sound_play('click')")
      b-icon(icon="chevron-left")
  template(slot="end")
    b-navbar-item.px_5_if_tablet(@click.native="sound_play('click')" tag="nuxt-link" :to="{name: 'video-studio-book_key-edit', params: {book_key: base.book.key}}" v-if="base.book && base.owner_p")
      b-icon(icon="pencil")
    b-navbar-item.px_5_if_tablet(@click.native="sound_play('click')" tag="nuxt-link" :to="{name: 'share-board', query: {...base.current_share_board_params, title: base.book.title}}" v-if="base.book")
      b-icon(icon="checkerboard")
    b-navbar-item.px_5_if_tablet(@click.native="base.download_handle" :href="base.book.lemon.browser_path" :download="base.book.lemon.filename_human" v-if="base.book")
      b-icon(icon="download")
    b-navbar-item.px_5_if_tablet(@click="base.tweet_handle" v-if="base.book")
      b-icon(icon="twitter")
    NavbarItemLogin
    NavbarItemProfileLink
    KiwiSidebarToggle(@click="base.sidebar_toggle"  v-if="false")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowNavbar
</style>
