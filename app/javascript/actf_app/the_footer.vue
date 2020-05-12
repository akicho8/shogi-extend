<template lang="pug">
.the_footer
  b-button(icon-left="crown" @click="app.ranking_handle")
  b-button(icon-left="menu" @click="app.ranking_handle")
</template>

<script>
import support from "./support.js"

export default {
  name: "the_footer",
  mixins: [
    support,
  ],
  mounted() {
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_footer
  z-index: 1

  position: fixed
  left: 0
  bottom: 0

  border-top: 1px solid $grey-lighter
  background: change_color($white-ter, $alpha: 0.96)

  height: 64px
  width: 100%

  padding: 0 16px

  display: flex
  justify-content: space-between
  align-items: center
</style>
