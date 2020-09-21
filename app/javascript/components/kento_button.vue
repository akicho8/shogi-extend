<template lang="pug">
  b-button.kento_button.is-small(v-bind="$attrs" v-on="$listeners" :target="target_default" @click="click_handle")
    span.left_icon
      | ☗
    span.name(v-if="!icon_only")
      | KENTO
</template>

<script>

export default {
  name: "kento_button",
  props: {
    icon_only: { default: false, },
  },
  methods: {
    click_handle() {
      this.$gtag.event("click", {event_category: "KENTO"})
    },
  },
}
</script>

<style lang="sass">
@import "../stylesheets/bulma_init.scss"
// https://www.kento-shogi.com/
.kento_button
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"
  font-weight: 700

  &:hover
    .left_icon
      animation: rotation 0.5s -0.25s ease-in-out infinite alternate

  .left_icon
    display: inline-block
    color: hsl(33, 91%, 65%)

  .name
    color: hsl(218, 23%, 23%)
    margin-left: 0.3rem

  @keyframes rotation
    0%
      transform: rotate(-20deg)
    100%
      transform: rotate(20deg)
</style>
