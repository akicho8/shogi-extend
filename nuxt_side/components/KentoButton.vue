<template lang="pug">
b-button.KentoButton.is-small(
  title="KENTO"
  v-bind="$attrs"
  v-on="$listeners"
  :target="target_default"
  @click="click_handle"
  )
  span.icon_left
    | ☗
  span.name(v-if="label_p")
    | KENTO
</template>

<script>

export default {
  name: "KentoButton",
  props: {
    label_p: { default: true, },
  },
  methods: {
    click_handle() {
      this.app_log("KENTO起動")
    },
  },
}
</script>

<style lang="sass">
// https://www.kento-shogi.com/
.KentoButton
  font-weight: bold
  &:hover
    .icon_left
      animation: rotation 0.5s -0.25s ease-in-out infinite alternate

  .icon_left
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
