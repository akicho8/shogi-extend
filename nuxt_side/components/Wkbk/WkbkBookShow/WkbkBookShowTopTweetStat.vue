<template lang="pug">
.WkbkBookShowTopTweetStat
  nav.panel.is-twitter.mb-0.has-background-white
    .panel-heading
      | 総合成績
    .panel-block.panel_body.is-justify-content-center
      | {{base.st_summary}}
    .panel-block
      TweetButton.is-link.is-outlined.is-fullwidth(:body="base.re_ox_tweet_body2" size="" @after_click="sfx_click()") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopTweetStat",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowTopTweetStat
  .panel_body
    white-space: pre-wrap
</style>
