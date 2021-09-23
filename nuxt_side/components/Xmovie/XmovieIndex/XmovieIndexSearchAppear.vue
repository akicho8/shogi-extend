<template lang="pug">
.XmovieIndexSearchAppear.is-hidden-desktop.columns(v-if="base.search_p || true")
  .column
    XmovieIndexSearch(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieIndexSearchAppear",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.XmovieIndexSearchAppear
</style>
