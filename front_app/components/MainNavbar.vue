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
      border: 1px dashed $danger
    +touch
      background: $purple
    +mobile
      background: $green
    +desktop
      background: $blue
    +widescreen
      background: $danger
    +fullhd
      background: $turquoise
</style>
