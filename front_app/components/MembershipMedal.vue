<template lang="pug">
.MembershipMedal.is-inline-block(@click="click_handle" :class="{is_clickable: params.message}")
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
      const message = this.params.message
      if (message) {
        this.sound_play("click")
        this.toast_ok(message)
      }
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
