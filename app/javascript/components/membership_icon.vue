<template lang="pug">
span.membership_icon
  template(v-if="typeof params === 'string'")
    | {{params}}
  template(v-else)
    b-icon(:icon="params.icon" :type="params.type" size="is-small" :class="params.class")
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
  margin-right: 0.5rem
</style>
