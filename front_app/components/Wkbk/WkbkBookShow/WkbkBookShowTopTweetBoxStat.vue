<template lang="pug">
.WkbkBookShowTopTweetBoxStat
  nav.panel.is-twitter.mb-0
    p.panel-heading
      | 総合成績
    .panel-block.jo_summary
      | {{base.jo_summary}}
    .panel-block
      TweetButton.is-link.is-outlined.is-fullwidth(:body="base.ox_tweet_body2" size="" @after_click="sound_play('click')") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopTweetBoxStat",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowTopTweetBoxStat
  .jo_summary
    white-space: pre-wrap
</style>
