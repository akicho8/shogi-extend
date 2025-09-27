<template lang="pug">
.modal-card.TrackLogModal
  .modal-card-head
    .modal-card-title
      | ログ ({{SB.track_logs.length}})

  .modal-card-body
    SbTrackLog(:SB="SB" ref="SbTrackLog")

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.close_handle(@click="test_handle" v-if="development_p") テスト
    b-button.close_handle(@click="clear_handle") クリア
</template>

<script>
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "TrackLogModal",
  mixins: [support_child],
  mounted() {
    this.SB.tl_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    test_handle() {
      this.sfx_click()
      this.SB.tl_test()
    },
    clear_handle() {
      this.sfx_click()
      this.SB.tl_clear()
    },
  },
}
</script>

<style lang="sass">
.TrackLogModal
  +modal_width(50rem)
  .modal-card-body
    padding: 0rem
</style>
