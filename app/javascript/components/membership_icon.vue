<template lang="pug">
  div
    | {{params}}
  //- b-icon.membership_icon(v-bind="$attrs" v-on="$listeners" size="is-small")
  //-   b-icon(icon="twitter" type="is-info" size="is-small")
  //-   span.turn(v-if="turn != null")
  //-     | \#{{turn}}
</template>

<script>

export default {
  name: "membership_icon",
  props: {
    params: { required: true },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.membership_icon
</style>
