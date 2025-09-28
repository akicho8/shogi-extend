<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title.is-flex-shrink-1
      | どっちのチームに参加する？
      template(v-if="SB.voted_result.already_vote_p(SB.user_name)")
        span.mx-1.has-text-grey.has-text-weight-normal
          | 投票済み
  .modal-card-body
    template(v-if="$gs.present_p(SB.received_odai.subject)")
      .subject.has-text-centered
        | {{SB.received_odai.subject}}
    template(v-if="$gs.present_p($gs.ary_compact_blank(SB.received_odai.items))")
      .items
        template(v-for="(e, i) in SB.received_odai.items")
          .item.is_line_break_on.is-clickable.is-unselectable(
            @click="select_handle(e, i)"
            :class="vote_select_item_class(i)"
            v-if="$gs.present_p(e)"
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
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"
import { support_child } from "../support_child.js"

export default {
  name: "ClientVoteModal",
  mixins: [support_child],
  methods: {
    // 選択
    select_handle(name, index) {
      if (this.SB.voted_latest_index !== index) {
        this.sfx_click()
        this.SB.sb_talk(name)
        this.SB.voted_latest_index = index
      }
    },
    // やめとく
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    // このチームに参加する
    submit_handle() {
      if (this.SB.voted_latest_index == null) {
        this.sfx_play("se_bubuu")
        this.toast_warn("選択してから投票してください")
        return
      }
      this.$emit("close")
      this.SB.vote_select_share()
    },
    // 選択した方の css クラス
    vote_select_item_class(i) {
      if (i === this.SB.voted_latest_index) {
        return "is_active"
      } else {
        return "is_inactive"
      }
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"

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
    align-items: stretch        // hover 時の枠の高さを揃えるため、高さを大きい方に統一する
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
        &:hover
          border: 3px dashed $primary
      &.is_active
        border: 3px solid $primary

.STAGE-development
  .ClientVoteModal
    .items
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
