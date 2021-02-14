<template lang="pug">
.WkbkTopSearchAppear.is-hidden-desktop.columns(v-if="base.search_p")
  .column
    WkbkTopSearch(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkTopSearchAppear",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkTopSearchAppear
</style>
