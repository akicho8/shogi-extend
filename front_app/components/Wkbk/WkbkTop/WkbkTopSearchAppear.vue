<template lang="pug">
.WkbkTopSearchAppear.is-hidden-desktop(v-if="base.search_p")
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
  +touch
    margin-top: 0.25rem
    margin-bottom: 1.25rem
</style>
