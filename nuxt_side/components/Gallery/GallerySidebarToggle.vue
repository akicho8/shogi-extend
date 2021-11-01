<template lang="pug">
b-navbar-item.GallerySidebarToggle(v-bind="$attrs" v-on="$listeners")
  b-icon(icon="menu")
</template>

<script>
import { all_support } from "./all_support.js"
export default {
  name: "GallerySidebarToggle",
  mixins: [all_support],
}
</script>

<style lang="sass">
@import "./all_support.sass"
.GallerySidebarToggle
  +tablet
    padding-left: 1.5rem
    padding-right: 1.5rem
</style>
