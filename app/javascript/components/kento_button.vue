<template lang="pug">
  b-button.kento_button(v-bind="$attrs" v-on="$listeners")
    span.left_icon
      | ☗
    span.name
      | KENTO
    span.turn(v-if="turn != null")
      | \#{{turn}}
</template>

<script>

export default {
  name: "kento_button",
  props: {
    turn: { required: false },
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

  .turn
    margin-left: 0.3rem

  @keyframes rotation
    0%
      transform: rotate(-20deg)
    100%
      transform: rotate(20deg)
</style>
