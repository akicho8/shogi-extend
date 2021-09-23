<template lang="pug">
b-field.KiwiLemonIndexSearch
  b-input(
    type="search"
    icon="magnify"
    icon-clickable
    @icon-click="base.search_handle"
    v-model.trim="base.query"
    rounded
    @keydown.native.enter="base.search_handle"
    )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonIndexSearch",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiLemonIndexSearch
</style>
