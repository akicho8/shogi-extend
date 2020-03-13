<template lang="pug">
  b-button.tweet_button(v-bind="$attrs" v-on="$listeners" size="is-small")
    b-icon(icon="twitter" type="is-info" size="is-small")
    span.turn(v-if="turn != null")
      | \#{{turn}}
</template>

<script>

export default {
  name: "tweet_button",
  props: {
    turn: { required: false },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.tweet_button
</style>
