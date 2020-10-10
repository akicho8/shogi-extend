<template lang="pug">
ShareBoardApp(:config="config")
</template>

<script>
export default {
  name: "share-board",
  head() {
    return {
      titleTemplate: null,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.config.twitter_card_options.title,       },
        { hid: "og:image",       property: "og:image",       content: this.config.twitter_card_options.image,       },
        { hid: "og:description", property: "og:description", content: this.config.twitter_card_options.description, },
        { hid: "description",    property: "description",    content: "リレー将棋・詰将棋の作成や公開・課題局面の作成や公開・オンライン対局向けリアルタイム盤共有などが可能です", },
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
