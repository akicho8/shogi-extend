<template lang="pug">
.WkbkBookShowTopTweetBoxRecent
  nav.panel.is-twitter.mb-0
    p.panel-heading
      | 直近成績
    .panel-block.recent_summary
      template(v-if="base.recent_summary")
        | {{base.recent_summary}}
      template(v-else)
        | ?
    .panel-block
      TweetButton.is-link.is-outlined.is-fullwidth(:body="base.ox_tweet_body1" size="" @after_click="sound_play('click')") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopTweetBoxRecent",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowTopTweetBoxRecent
  .recent_summary
    white-space: pre-wrap
</style>
