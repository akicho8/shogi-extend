<template lang="pug">
Mainsection.WkbkBookShowGoal
  .container.is-fluid
    .columns
      .column
        .is-flex.is-justify-content-center
          .card.is-inline-block
            .card-content
              p.title.is-size-6
                | 結果
              //- p.subtitle
              //-   | Jeff Atwood
              p
                | {{base.re_summary}}
            .card-footer
              p.card-footer-item
                TweetButton(:body="base.re_ox_tweet_body1" @after_click="sfx_play_click()") Tweet

        //- .is-flex.is-justify-content-center
        //-   .box.has-text-centered.is-inline-block.is-shadowless
        //-     | {{base.re_summary}}
        //-     TweetButton.mt-2(:body="base.re_ox_tweet_body1") Tweet

        .buttons.is-centered.mt-4
          //- b-button(@click="base.play_start") もう一度挑戦する
          b-button(@click="base.close_handle") もどる
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
  .card-content
    white-space: pre-wrap
</style>
