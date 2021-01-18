<template lang="pug">
.WbookRankingRow.is-flex(:class="{active: base.current_user && row.user.id === base.current_user.id}" @click="base.ov_user_info_set(row.user.id)")
  .rank_block
    .rank.is-size-5.has-text-weight-bold.has-text-right.has-text-primary
      | {{row.rank}}
  figure.image.is-48x48.avatar_path
    img.is-rounded(:src="row.user.avatar_path")
  .name_with_rating
    .user_name.has-text-weight-bold.is_truncate
      | {{row.user.name}}
      span.ml-1.has-text-primary.is_line_break_off(v-if="base.debug_read_p") {{row.user.skill_key}}
    .value
      template(v-if="$parent.current_tab_info.key === 'rating' && (base.config.rating_display_p || development_p)")
        | {{rating_format(row.user.wbook_season_xrecord.rating)}}
      template(v-if="$parent.current_tab_info.key === 'straight_win_count'")
        | {{row.user.wbook_season_xrecord.straight_win_count}}
      template(v-if="$parent.current_tab_info.key === 'straight_win_max'")
        | {{row.user.wbook_season_xrecord.straight_win_max}}
      span(v-if="$parent.current_tab_info.unit")
        | {{$parent.current_tab_info.unit}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WbookRankingRow",
  mixins: [
    support_child,
  ],
  props: {
    row: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.WbookRankingRow
  padding-top: 1rem
  padding-bottom: 0.7rem

  &.active
    background-color: change_color($warning, $lightness: 97%)

  &:not(:first-child)
    border-top: 1px solid $grey-lighter

  justify-content: flex-start
  align-items: center

  .rank_block
    min-width: 3rem
  .image
    margin-left: 1rem
    img
      height: 48px

  .name_with_rating
    margin-left: 1rem
    .user_name
      max-width: 12rem
    .rating
</style>
