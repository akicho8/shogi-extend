<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 対局履歴
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(:href="SB.dashboard_url" target="_blank")
        b-icon(icon="link")
  .modal-card-body
    SbDashboardBody(:room_key="SB.room_key")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDashboardModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDashboardModal
  // +modal_width_auto
  +modal_max_width(640px)
  .modal-card-body
    padding: 1rem
    // background-color: $grey-darker
</style>
