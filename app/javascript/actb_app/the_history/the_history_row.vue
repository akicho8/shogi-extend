<template lang="pug">
.the_history_row.is-flex(@click="app.ov_question_info_set(row.question.id)")
  .left_block.is-flex

    .ox_mark
      template(v-if="row.ox_mark")
        b-icon(v-if="row.ox_mark.key === 'correct'" size="is-small" icon="checkbox-blank-circle-outline" type="is-danger")
        b-icon(v-if="row.ox_mark.key === 'mistake'" size="is-small" icon="close"                         type="is-success")
        b-icon(v-if="row.ox_mark.key === 'timeout'" size="is-small" icon="timer-sand-empty" class="has-text-grey-light")

    img.board(:src="board_image_url")

    figure.image.is-16x16.is_flex_shrink_0(@click.stop="app.ov_user_info_set(row.question.user.id)")
      img.is-rounded(:src="row.question.user.avatar_path")
    .question_block.is-flex
      .uegawa
        .question_title.has-text-weight-bold(v-if="row.question.title")
          | {{row.question.title}}
        .question_user.is-size-7.has-text-grey
          template(v-if="row.question.source_about_key === 'unknown'")
            | 作者不詳
          template(v-else)
            | {{row.question.display_author}}
            span.is-size-11 作
        .question_description.is-size-7(v-if="row.question.description")
          | {{string_truncate(row.question.description)}}
      .bottom_block.is-flex
        the_history_row_vote(:row="row")
</template>

<script>
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
    row:  { required: true },
  },
  created() {
    // this.row.question.description = "あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ"
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

  // &.active
  //   background-color: change_color($warning, $lightness: 97%)

  &:not(:first-child)
    border-top: 1px solid $grey-lighter

  justify-content: space-between
  align-items: flex-start

  .ox_mark
    min-width: 1rem           // ←この調整がむずい。保存リストのときに左側にマージンを作る
    margin-top: 0rem
    margin-left: 0.5rem

  .board
    height: 96px
    width: 168px - 32px - 8px
    object-fit: cover
    object-position: 50% 50%

  .image
    margin-top: 0.2rem

  .question_block
    margin-left: 0.25rem

    flex-direction: column
    justify-content: space-between
    align-items: flex-start

    .question_title
    .bottom_block
</style>
