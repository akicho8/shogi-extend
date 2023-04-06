<template lang="pug">
.SbDashboard
  MainNavbar
    template(slot="brand")
      NavbarItemHome(icon="chevron-left" :to="{name: 'share-board', query: {room_code: room_code}}")
      b-navbar-item.has-text-weight-bold(tag="div")
        | {{room_code}}
  MainSection
    .container
      SbDashboardBody(:room_code="room_code")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDashboard",
  mixins: [support_child],
  computed: {
    room_code() { return this.$route.query.room_code },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
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
