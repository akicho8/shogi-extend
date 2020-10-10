<template lang="pug">
client-only
  ShareBoardApp(:config="config")
</template>

<script>
export default {
  name: "share-board",
  head() {
    return {
      title: this.config.twitter_card_options.title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.config.twitter_card_options.title       },
        { hid: "og:image",       property: "og:image",       content: this.config.twitter_card_options.image,      },
        { hid: "og:description", property: "og:description", content: this.config.twitter_card_options.description },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/share_board
    const config = await $axios.$get("/api/share_board", {params: query})
    return { config }
  },
}
</script>

<style lang="sass">
</style>
