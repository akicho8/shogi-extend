<template lang="pug">
.KiwiTopSearchAppear.is-hidden-desktop.columns(v-if="base.search_p || true")
  .column
    KiwiTopSearch(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiTopSearchAppear",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiTopSearchAppear
</style>
