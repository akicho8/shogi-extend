<template lang="pug">
span.membership_medal
  template(v-if="typeof params === 'string'")
    span.emoji
      | {{params}}
  template(v-else)
    b-icon(:icon="params.icon" :type="params.type" size="is-small" :class="params.class")
</template>

<script>

export default {
  name: "membership_medal",
  props: {
    params: { required: true },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
.membership_medal
  .emoji
    margin-right: 0.25rem
  .icon
    margin-right: 0.6rem
</style>
