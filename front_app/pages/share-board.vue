<template lang="pug">
ShareBoardApp(:config="config")
</template>

<script>
import _ from "lodash"

export default {
  name: "share-board",
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:3000/api/share_board
    const config = await $axios.$get("/api/share_board", {params: query})
    return { config }
  },
  mounted() {
    if (_.isEmpty(this.$route.query)) {
      this.ga_click("共有将棋盤")
    } else {
      this.ga_click("共有将棋盤●")
    }
  },
  computed: {
    meta() {
      return {
        short_title: true,
        title: this.config.twitter_card_options.title,
        description: "リレー将棋・詰将棋の作成や公開・課題局面の作成や公開・オンライン対局向けリアルタイム盤共有などが可能です",
        og_description: this.config.twitter_card_options.description,
        og_image: this.config.twitter_card_options.image,
      }
    }
  },
}
</script>

<style lang="sass">
</style>
