<template lang="pug">
.WkbkBookShowStandby
  //- .columns.is-gapless
  //-   .column
  //-     .box.is-shadowless.has-background-white-ter(v-if="base.book.description" v-html="simple_format(auto_link(base.book.description))")
  //-     .buttons
  //-       b-button(@click="base.play_restart") スタート

  .is-flex.is-justify-content-center
    .hero
      .hero-body
        p.title
          | {{base.book.title}}
        p.subtitle(v-if="base.book.description" v-html="simple_format(auto_link(base.book.description))")
          | Primary subtitle

  .columns.is-gapless
    .column
      .buttons
        b-button(@click="base.play_restart") START
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowStandby",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowStandby
    .column, .book_container
      border: 1px dashed change_color($primary, $alpha: 0.5)

.WkbkBookShowStandby
  // margin: $wkbk_share_gap
  .column
    display: flex
    justify-content: center
    align-items: center
    flex-direction: column

  .hero
    +tablet
      width: 65ch

  // .box
  //   width: 100%
  //   +tablet
  //     width: 65ch
</style>
