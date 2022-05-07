<template lang="pug">
MainNavbar.XyMasterNavbar(v-if="base.is_mode_idol")
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'xy'}") 符号の鬼
  template(slot="end")
    NavbarItemLogin
    NavbarItemProfileLink
    NavbarItemSidebarOpen(@click="base.sidebar_toggle")
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
