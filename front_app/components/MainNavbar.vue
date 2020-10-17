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
  // touch以下で is-spaced の左右の padding が外れ navbar-item が画面端にくっついてしまうため少し隙間を入れる
  +touch
    padding-left: 32px
    padding-right: 32px
  // さらにモバイル時はさらに上下の隙間がもったいないので is-spaced の上下を無効にする
  +mobile
    padding-top: 0
    padding-bottom: 0

.STAGE-development
  .navbar.MainNavbar
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
