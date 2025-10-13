<template lang="pug">
b-button.TweetButton.has-text-weight-bold(
  v-bind="$attrs"
  v-on="$listeners"
  :size="size"
  :type="type"
  icon-left="twitter"
  @click="click_handle"
  :rounded="false")
  slot
</template>

<script>
export default {
  name: "TweetButton",
  props: {
    body: { type: String, required: true,  default: "",           },
    type: { type: String, required: false, default: "is-twitter", },
    size: { type: String, required: false, default: "is-small",   },
  },
  methods: {
    click_handle() {
      this.$GX.assert(this.body, "this.body")
      this.tweet_window_popup({text: this.body})
      this.$emit("after_click")
    },
  },
}
</script>

<style lang="sass">
.TweetButton
  __css_keep__: 0
</style>
