<template lang="pug">
.WkbkBookShowTopTweetRecent
  nav.panel.is-twitter.mb-0.has-background-white
    .panel-heading
      | 直近成績
    .panel-block.panel_body.is-justify-content-center
      template(v-if="base.re_summary")
        | {{base.re_summary}}
      template(v-else)
        br
        | ?
        br
        br
    .panel-block
      TweetButton.is-link.is-outlined.is-fullwidth(:body="base.re_ox_tweet_body1" size="" @after_click="sfx_play_click()") ツイート
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopTweetRecent",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowTopTweetRecent
  .panel_body
    white-space: pre-wrap
</style>
