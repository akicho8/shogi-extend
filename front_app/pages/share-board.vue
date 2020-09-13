<template lang="pug">
client-only
  .share-board
    ShareBoardApp(:info="info")
</template>

<script>
export default {
  name: "share-board",
  head() {
    return {
      title: this.info.twitter_card_options.title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.info.twitter_card_options.title               },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                              },
        { hid: "og:image",       property: "og:image",       content: this.$config.BASE_URL_OGP + "/ogp/share-board.png" },
        { hid: "og:description", property: "og:description", content: this.info.twitter_card_options.title.description   },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/share_board?info_fetch=true
    const info = await $axios.$get("/api/share_board", {params: {info_fetch: true, ...query}})
    return { info }
  },
}
</script>

<style lang="sass">
.share-board
</style>
