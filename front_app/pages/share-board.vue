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
      title: "共有将棋盤",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "共有将棋盤"                                                     },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                            },
        { hid: "og:image",       property: "og:image",       content: this.$config.BASE_URL_OGP + "/ogp/share-board.png"               },
        { hid: "og:description", property: "og:description", content: "リレー将棋・詰将棋の共有・オンライン盤共有などができるサービス" },
      ],
    }
  },
  async asyncData({ $axios }) {
    // http://0.0.0.0:3000/api/share_board?info_fetch=true
    const info = await $axios.$get("/api/share_board", {params: {info_fetch: true}})
    return { info }
  },
  created() {
    
  },
}
</script>

<style lang="sass">
.share-board
</style>
