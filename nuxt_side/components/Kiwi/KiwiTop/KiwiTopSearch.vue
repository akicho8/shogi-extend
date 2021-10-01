<template lang="pug">
b-field.KiwiTopSearch
  b-input(
    type="search"
    icon="magnify"
    icon-clickable
    @icon-click="base.search_handle"
    v-model.trim="base.query"
    :rounded="false"
    @keydown.native.enter="base.search_handle"
    )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiTopSearch",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiTopSearch
  +mobile
    max-width: 10rem
</style>
