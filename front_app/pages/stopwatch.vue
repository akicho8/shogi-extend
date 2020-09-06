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
      title: "対局時計",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "対局時計"                                                       },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary"                                                        },
        { hid: "og:image",       property: "og:image",       content: this.$config.OGP_SITE_URL + "/ogp/stopwatch-1200x630.png"         },
        { hid: "og:description", property: "og:description", content: "ネット対局と同じような持ち時間のプリセットが入った対局時計です" },
      ],
    }
  },
}
</script>

<style lang="sass">
.stopwatch
</style>
