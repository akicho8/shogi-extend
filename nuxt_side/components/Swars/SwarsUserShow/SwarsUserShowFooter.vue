<template lang="pug">
.SwarsUserShowFooter.is-clickable(
  v-if="!TheApp.filter_modal_p && $route.query.query"
  @click="TheApp.filter_modal_handle"
  v-text="$route.query.query"
  )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowFooter",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowFooter
  position: fixed
  bottom: 0
  left: 0
  right: 0

  overflow-x: auto
  overscroll-behavior-x: none

  display: flex
  justify-content: center
  color: $white
  font-size: $size-7
  white-space: nowrap
  background-color: hsla(0, 0%, 0%, 0.75)
  line-height: 2.0
</style>
