<template lang="pug">
b-navbar-item.WkbkSidebarToggle(v-bind="$attrs" v-on="$listeners")
  b-icon(icon="menu")
</template>

<script>
import { support } from "./support.js"
export default {
  name: "WkbkSidebarToggle",
  mixins: [support],
}
</script>

<style lang="sass">
@import "./support.sass"
.WkbkSidebarToggle
  +tablet
    padding-left: 1.5rem
    padding-right: 1.5rem
</style>
