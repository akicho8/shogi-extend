<template lang="pug">
.MembershipMedal.is-inline-block.is_clickable(@click="click_handle")
  template(v-if="params.emoji")
    span.emoji
      | {{params.emoji}}
  template(v-else-if="params.icon")
    b-icon(:icon="params.icon" :type="params.type" size="is-small" :class="params.class")
  template(v-else)
    | {{params}}
</template>

<script>
export default {
  name: "MembershipMedal",
  props: {
    params: { type: Object, required: true },
  },
  methods: {
    click_handle() {
      this.sound_play("click")
      this.toast_ok(this.params.message)
    },
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
