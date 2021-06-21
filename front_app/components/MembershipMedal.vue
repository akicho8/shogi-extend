<template lang="pug">
.MembershipMedal(:class="wrapper_class" @click="click_handle")
  template(v-if="false")
  .xemoji_wrap(v-else-if="params.emoji" v-xemoji) {{params.emoji}}
  b-icon(v-else-if="params.icon" :icon="params.icon" :type="params.type" size="is-small" :class="params.class")
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
  computed: {
    wrapper_class() {
      return {
        my_emoji: this.params.emoji,
        my_icon:  this.params.icon,
        // my_raw:   !(this.params.emoji || this.params.icon),
        "is-clickable": this.params.message,
      }
    },
  },
}
</script>

<style lang="sass">
.MembershipMedal
  display: flex
  align-items: center
  justify-content: center

  .xemoji_wrap
    display: flex

  .xemoji, .icon
    height: 1em
    width: unset

  margin-right: 0.3em

.STAGE-development
  .MembershipMedal
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .xemoji_wrap, .icon
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
