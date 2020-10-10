<template lang="pug">
client-only
  .stopwatch
    StopwatchApp
</template>

<script>
export default {
  name: "stopwatch",
  head() {
    return {
      title: "詰将棋用ストップウォッチ",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "詰将棋用ストップウォッチ"                          },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/stopwatch.png"       },
        { hid: "og:description", property: "og:description", content: "詰将棋を繰り返し解くのに特化したストップウォッチです" },
      ],
    }
  },
}
</script>

<style lang="sass">
.stopwatch
</style>
