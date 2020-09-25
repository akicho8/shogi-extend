<template lang="pug">
.MembershipMedal.is-inline-block
  template(v-if="typeof params === 'string'")
    span.emoji
      | {{params}}
  template(v-else)
    b-icon(:icon="params.icon" :type="params.type" size="is-small" :class="params.class")
</template>

<script>

export default {
  name: "MembershipMedal",
  props: {
    params: { required: true },
  },
}
</script>

<style lang="sass">
.MembershipMedal
  .emoji
    margin-right: 0.25rem
  .icon
    margin-right: 0.6rem
</style>
