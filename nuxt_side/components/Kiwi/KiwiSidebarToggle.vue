<template lang="pug">
b-navbar-item.KiwiSidebarToggle(v-bind="$attrs" v-on="$listeners")
  b-icon(icon="menu")
</template>

<script>
import { support } from "./support.js"
export default {
  name: "KiwiSidebarToggle",
  mixins: [support],
}
</script>

<style lang="sass">
@import "./support.sass"
.KiwiSidebarToggle
  +tablet
    padding-left: 1.5rem
    padding-right: 1.5rem
</style>
