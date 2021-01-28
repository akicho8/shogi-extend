<template lang="pug">
.WkbkBookShowGoal
  .columns.is-gapless
    .column
      .is-flex.is-justify-content-center
        .box.has-text-centered.is-inline-block
          | {{base.ox_summary}}
          TweetButton.mt-2(:body="base.ox_tweet_body")
      .buttons.is-centered.mt-4
        b-button(@click="base.play_restart") もう一度挑戦する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowGoal",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowGoal
  margin: $wkbk_share_gap
  .box
    white-space: pre-wrap
</style>
