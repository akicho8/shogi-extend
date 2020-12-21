<template lang="pug">
b-navbar.MainNavbar(v-bind="navbar_attrs" v-on="$listeners")
  // FIXMME: これどうにかなんないの？
  template(slot="brand")
    slot(name="brand")
  template(slot="start")
    slot(name="start")
  template(slot="end")
    slot(name="end")
</template>

<script>
export default {
  name: "MainNavbar",
  computed: {
    navbar_attrs() {
      return {
        "type": "is-primary",
        "mobile-burger": false,
        "wrapper-class": "container",
        "spaced": true,
        ...this.$attrs,
      }
    },
  },
}
</script>

<style lang="sass">
.navbar.MainNavbar
  +touch
    padding: 0 // is-spaced を無効化

.STAGE-development
  .navbar.MainNavbar
    border: 1px dashed $primary
    .navbar-item
      border: 1px dashed change_color($white, $alpha: 0.2)
    position: relative
    &:after
      position: absolute
      @extend %overlay
      z-index: -1
      display: flex
      align-items: center
      justify-content: center
      font-size: $size-7
      +touch
        content: "touch"
      +mobile
        content: "mobile"
      +desktop
        content: "desktop"
      +widescreen
        content: "widescreen"
      +fullhd
        content: "fullhd"
</style>
