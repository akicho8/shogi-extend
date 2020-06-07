<template lang="pug">
.the_ranking_row.is-flex(:class="{active: row.user.id === app.current_user.id}" @click="app.ov_user_info_set(row.user.id)")
  .rank_block
    .rank.is-size-5.has-text-weight-bold.has-text-right.has-text-primary
      | {{row.rank}}
  figure.image.is-48x48
    img.is-rounded(:src="row.user.avatar_path")
  .name_with_rating
    .name.has-text-weight-bold
      | {{row.user.name}}
    .rating
      | {{row.user[$parent.current_tab_info.key]}}
      span.unit(v-if="$parent.current_tab_info.unit")
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
      .unit
        margin-left: 0.2rem
</style>
