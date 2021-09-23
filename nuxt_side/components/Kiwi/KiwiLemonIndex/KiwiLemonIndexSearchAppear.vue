<template lang="pug">
.KiwiLemonIndexSearchAppear.is-hidden-desktop.columns(v-if="base.search_p || true")
  .column
    KiwiLemonIndexSearch(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonIndexSearchAppear",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiLemonIndexSearchAppear
</style>
