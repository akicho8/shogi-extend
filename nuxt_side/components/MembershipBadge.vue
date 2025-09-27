<template lang="pug">
.MembershipBadge(:class="wrapper_class" @click="click_handle")
  XemojiWrap(v-if="params.emoji" :str="params.emoji")
  b-icon(v-else-if="params.icon" :icon="params.icon" :type="params.type" size="is-small" :class="params.class")
  template(v-else) {{params}}
</template>

<script>
export default {
  name: "MembershipBadge",
  props: {
    params: { type: Object, required: true },
  },
  methods: {
    click_handle() {
      const message = this.params.message
      if (message) {
        this.sfx_click()
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
.MembershipBadge
  flex-shrink: 0                // 絵文字潰れを防ぐ

  display: flex
  align-items: center
  justify-content: center

  .XemojiWrap
    display: flex

  .xemoji, .icon
    height: 1em
    width: unset

  margin-right: 0.3em

.STAGE-development
  .MembershipBadge
    border: 1px dashed change_color($primary, $alpha: 0.5)
    .xemoji_wrap, .icon
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
