<template lang="pug">
  b-button.kento_app_button(v-on="$listeners")
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
.kento_app_button
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol"
  font-weight: 700

  .left_icon
    display: inline-block
    color: hsl(33, 91%, 65%)
    +icon_rorate_if_button_hover("kento_app_button")
      animation: rotation

  .name
    color: hsl(218, 23%, 23%)
    margin-left: 0.3rem

  .turn
    margin-left: 0.3rem

// @keyframes rotation
//   0%
//     transform: rotate(-360deg)
//   100%
//     transform: rotate(360deg)
</style>
