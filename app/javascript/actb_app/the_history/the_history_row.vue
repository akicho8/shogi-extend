<template lang="pug">
.the_history_row.is-flex(@click="app.ov_question_info_set(row.question.id)")
  .left_block.is-flex
    .ox_mark(v-if="row.ox_mark")
      template(v-if="row.ox_mark.key === 'correct'")
        b-icon(icon="checkbox-blank-circle-outline" type="is-danger")
      template(v-if="row.ox_mark.key === 'mistake'")
        b-icon(icon="close" type="is-success")
      template(v-if="row.ox_mark.key === 'timeout'")
        b-icon(icon="timer-sand-empty")
    img.board(:src="board_image_url")
    figure.image.is-32x32
      img.is-rounded(:src="row.question.user.avatar_path")
    .question_block.is-flex
      .uegawa
        .question_user.is-size-6.has-text-grey
          | {{row.question.display_author}}
          span.question_user_unit.has-text-grey 作
        .question_title.has-text-weight-bold(v-if="row.question.title")
          | {{row.question.title}}
        .question_description(v-if="row.question.description")
          | {{row.question.description}}
      .bottom_block.is-flex
        the_history_row_vote(:row="row")
</template>

<script>
import MemoryRecord from 'js-memory-record'

import { support } from "../support.js"

import the_history_row_vote from "./the_history_row_vote.vue"

export default {
  name: "the_history_row",
  mixins: [
    support,
  ],
  components: {
    the_history_row_vote,
  },
  props: {
    row: { required: true },
  },
  computed: {
    board_image_url() {
      // return "/share-board.png?body=position+sfen+ln1g1g1nl%2F1ks2r3%2F1pppp1bpp%2Fp3spp2%2F9%2FP1P1SP1PP%2F1P1PP1P2%2F1BK1GR3%2FLNSG3NL+b+-+1&turn=0&title=%E3%83%AA%E3%83%AC%E3%83%BC%E5%B0%86%E6%A3%8B&image_view_point=black&image_preset=small"
      const params = {
        format: "png",
        body: this.row.question.init_sfen,
        image_view_point: "black",
      }
      const url = new URL(this.as_full_url("/share-board"))
      _.each(params, (v, k) => url.searchParams.set(k, v))
      return url.toString()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.the_history_row
  padding-top: 0.5rem
  padding-bottom: 0.5rem

  &.active
    background-color: change_color($warning, $lightness: 97%)

  &:not(:first-child)
    border-top: 1px solid $grey-lighter

  justify-content: space-between
  align-items: flex-start

  .ox_mark
    margin-top: 0.5rem
    margin-left: 1.0rem
  .board
    height: 128px
    width: 172px
    object-fit: cover
    object-position: 50% 50%
  .image
    margin-top: 0.25rem
  .question_block
    margin-left: 0.5rem
    flex-direction: column
    justify-content: space-between
    align-items: flex-start
    .question_title
    .bottom_block

    .question_user_unit
      margin-left: 0.1rem
      font-size: 0.75rem
</style>
