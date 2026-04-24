<template lang="pug">
.FetchStateErrorMessage(v-if="fetchState.error")
  .text-block.is_line_break_on.has-text-weight-bold(v-text="fetchState.error.message")
</template>

<script>
export default {
  name: "FetchStateErrorMessage",
  props: {
    fetchState: { type: Object, required: true, },
  },
}
</script>

<style lang="sass">
.FetchStateErrorMessage
  position: fixed
  inset: 0
  color: $white
  background-color: change_color($primary, $alpha: 0.9)
  padding: 1rem
  z-index: 200
  overflow: auto

  .text-block
    width: 100%
    height: 100%
    margin: auto
</style>
