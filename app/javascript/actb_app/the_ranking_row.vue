<template lang="pug">
.the_ranking_row.is-flex(:class="{active: app.current_user && row.user.id === app.current_user.id}" @click="app.ov_user_info_set(row.user.id)")
  .rank_block
    .rank.is-size-5.has-text-weight-bold.has-text-right.has-text-primary
      | {{row.rank}}
  figure.image.is-48x48
    img.is-rounded(:src="row.user.avatar_path")
  .name_with_rating
    .name.has-text-weight-bold
      | {{row.user.name}}
      span.ml-1.has-text-primary(v-if="app.debug_mode_p") {{row.user.udemae_key}}
    .value
      template(v-if="$parent.current_tab_info.key === 'rating' && app.config.rating_display_p")
        | R{{row.user.actb_season_xrecord.rating}}
      template(v-if="$parent.current_tab_info.key === 'rensho_count'")
        | {{row.user.actb_season_xrecord.rensho_count}}
      template(v-if="$parent.current_tab_info.key === 'rensho_max'")
        | {{row.user.actb_season_xrecord.rensho_max}}
      span.unit.ml-1.has-text-weight-normal.has-text-grey(v-if="$parent.current_tab_info.unit")
        | {{$parent.current_tab_info.unit}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_ranking_row",
  mixins: [
    support,
  ],
  props: {
    row: { type: Object, required: true },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_ranking_row
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
    .name
    .rating
</style>
