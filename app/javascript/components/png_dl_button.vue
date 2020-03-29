<template lang="pug">
  b-button.png_dl(v-bind="$attrs" v-on="$listeners" size="is-small" icon-left="download")
    span.turn(v-if="turn != null")
      | \#{{turn}}
</template>

<script>

export default {
  name: "png_dl",
  props: {
    turn: { required: false },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.png_dl
</style>
