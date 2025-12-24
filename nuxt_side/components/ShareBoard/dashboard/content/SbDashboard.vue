<template lang="pug">
.SbDashboard
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'share-board', query: {room_key: room_key}}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | {{room_key}}
  MainSection
    .container
      SbDashboardBody(:room_key="room_key")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SbDashboard",
  mixins: [support_child],
  computed: {
    room_key() { return this.$route.query.room_key },
  },
}
</script>

<style lang="sass">
@import "../../sass/support.sass"
.SbDashboard
  min-height: 100svh
  background-color: $white-ter
  .MainSection.section
    padding: 1rem

.STAGE-development
  .SbDashboard
    .container, .section
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
