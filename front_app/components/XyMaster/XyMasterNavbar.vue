<template lang="pug">
MainNavbar.XyMasterNavbar(v-if="base.is_mode_idol")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'xy'}") 符号の鬼
  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink
    b-navbar-item.px_5_if_tablet.sidebar_toggle_navbar_item(@click="base.sidebar_toggle")
      b-icon(icon="menu")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XyMasterNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "./support.sass"
.XyMasterNavbar
</style>
