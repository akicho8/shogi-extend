<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex-shrink-1
      | どのチームに参加する？
      template(v-if="TheSb.voted_result.already_vote_p(TheSb.user_name)")
        span.mx-1.has-text-grey.has-text-weight-normal
          | 投票済み
  .modal-card-body
    template(v-if="present_p(TheSb.received_odai.subject)")
      .subject.has-text-centered
        | {{TheSb.received_odai.subject}}
    template(v-if="present_p(ary_compact_blank(TheSb.received_odai.items))")
      .items
        template(v-for="(e, i) in TheSb.received_odai.items")
          .item.is_line_break_on.is-clickable.is-unselectable(
            @click="select_handle(e, i)"
            :class="vote_select_item_class(i)"
            v-if="present_p(e)"
            )
            | {{e}}
    template(v-else)
      .has-text-centered
        | 選択肢がありません
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle") やめとく
    b-button(@click="submit_handle" type="is-primary") このチームに参加する
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
    // 選択
    select_handle(name, index) {
      if (this.TheSb.voted_latest_index !== index) {
        this.$sound.play_click()
        this.TheSb.talk2(name)
        this.TheSb.voted_latest_index = index
      }
    },
    // やめとく
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    // このチームに参加する
    submit_handle() {
      this.$sound.play_click()
      if (this.TheSb.voted_latest_index == null) {
        this.toast_warn("選択してから投票してください")
        return
      }
      this.$emit("close")
      this.TheSb.vote_select_share()
    },
    // 選択した方の css クラス
    vote_select_item_class(i) {
      if (i === this.TheSb.voted_latest_index) {
        return "is_active"
      } else {
        return "is_inactive"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"

.ClientVoteModal
  +modal_width(30rem)

  .modal-card-body
    padding: 20px
    display: flex
    justify-content: center
    flex-direction: column
    gap: 0.5rem

  .modal-card-foot
    .button
      min-width: 6rem

  .items
    display: flex
    align-items: center
    justify-content: center
    .item
      display: flex
      align-items: center
      justify-content: center
      width: 100% // 両方を均等する。内容に比例する場合は flex-basis: content にする
      padding: 1rem
      border-radius: 0.5rem
      +tablet
        font-size: 1.5rem
      &.is_inactive
        border: 3px solid transparent
      &.is_active
        border: 3px solid $primary

.STAGE-development
  .ClientVoteModal
    .items
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
