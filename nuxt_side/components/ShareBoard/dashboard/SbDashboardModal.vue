<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 集計結果
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(:href="base.dashboard_url" target="_blank")
        b-icon(icon="link")
  .modal-card-body
    SbDashboardBody(:room_code="base.room_code")
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
@import "../support.sass"
.SbDashboardModal
  +modal_max_width(600px)
  .modal-card-body
    padding: 1rem
    // background-color: $grey-darker
</style>
