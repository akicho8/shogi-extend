<template lang="pug">
MainNavbar.StopwatchNavbar
  template(slot="brand")
    NavbarItemHome
    b-navbar-item.has-text-weight-bold(@click="base.book_title_input_dialog") {{base.book_title}}
  template(slot="end")
    NavbarItemSidebarOpen(@click="base.sidebar_toggle")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "StopwatchNavbar",
  mixins: [support_child],
}
</script>

<style lang="sass">
// @import "./support.sass"
// .StopwatchNavbar
</style>
