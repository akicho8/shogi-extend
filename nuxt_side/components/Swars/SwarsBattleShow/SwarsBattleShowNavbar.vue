<template lang="pug">
MainNavbar.SwarsBattleShowNavbar
  template(slot="brand")
    b-navbar-item(@click="base.back_handle")
      b-icon(icon="chevron-left")
    b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'swars-battles-key', params: {key: $route.params.key}, query: {turn: base.current_turn, viewpoint: base.viewpoint}}")
      | \#{{base.current_turn}}
  template(slot="end")
    b-navbar-item.px_5_if_tablet.has-text-weight-bold(@click="base.tweet_handle")
      b-icon(icon="twitter")
    NavbarItemSidebarOpen(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleShowNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsBattleShowNavbar
  __css_keep__: 0
</style>
