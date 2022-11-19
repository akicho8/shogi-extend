<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title {{TheSb.odai_fixed.subject}}
  .modal-card-body
    .items
      template(v-for="(e, i) in TheSb.odai_fixed.items")
        .item.is_line_break_on.is-clickable(@click="select_handle(e, i)" :class="vote_select_item_class(i)")
          | {{e}}
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle") やめとく
    b-button(@click="submit_handle" type="is-primary") 投票する
</template>

<script>
import { support_child } from "../support_child.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export default {
  name: "ClientVoteModal",
  mixins: [support_child],
  inject: ["TheSb"],
  methods: {
    select_handle(name, index) {
      this.$sound.play_click()
      this.talk(name)
      this.TheSb.voted_latest_index = index
    },
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    submit_handle() {
      this.$sound.play_click()
      if (this.TheSb.voted_latest_index == null) {
        this.toast_warn("投票してから押してください")
        return
      }
      this.$emit("close")
      this.TheSb.fes_vote_selected_share()
    },
    vote_select_item_class(i) {
      if (i === this.TheSb.voted_latest_index) {
        return "is_active"
      } else {
        return "is_inactive"
      }
    },
  },
  computed: {
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.ClientVoteModal
  +modal_width(30rem)

  .modal-card-body
    padding: 20px

  .modal-card-foot
    .button
      min-width: 6rem

  .items
    display: flex
    align-items: center
    justify-content: center
    gap: 20px
    .item
      display: flex
      align-items: center
      justify-content: center
      width: 100%
      padding: 1rem
      border-radius: 0.5rem
      font-size: 2rem
      &.is_inactive
        // background-color: $white-ter
        border: 3px solid transparent
      &.is_active
        // background-color: $primary-light
        border: 3px solid $primary
        // color: $primary

.STAGE-development
  .ClientVoteModal
    .items
      // border: 1px dashed change_color($primary, $alpha: 0.5)
    .item
      // border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
