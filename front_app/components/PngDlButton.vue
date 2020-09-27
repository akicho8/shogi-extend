<template lang="pug">
  b-button.PngDlButton(v-bind="$attrs" v-on="$listeners" size="is-small" icon-left="download")
    span.name
      | PNG
    span.turn(v-if="turn != null && false")
      | \#{{turn}}
</template>

<script>

export default {
  name: "PngDlButton",
  props: {
    turn: { required: false },
  },
}
</script>

<style lang="sass">
.PngDlButton
</style>
