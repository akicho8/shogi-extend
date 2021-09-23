<template lang="pug">
b-navbar-item.XmovieSidebarToggle(v-bind="$attrs" v-on="$listeners")
  b-icon(icon="menu")
</template>

<script>
import { support } from "./support.js"
export default {
  name: "XmovieSidebarToggle",
  mixins: [support],
}
</script>

<style lang="sass">
@import "./support.sass"
.XmovieSidebarToggle
  +tablet
    padding-left: 1.5rem
    padding-right: 1.5rem
</style>
