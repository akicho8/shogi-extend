<template lang="pug">
client-only
  //- client-only しないと ShareBoardApp の beforeMount が呼ばれる前に render されたりともうめちくちゃなことになる
  ShareBoardApp(:config="config" v-if="config")
</template>

<script>
export default {
  name: "share-board",
  async asyncData({ $axios, query }) {
    const e = await $axios.$get("/api/share_board", {params: query})
    if (e.bs_error) {
      return { bs_error: e.bs_error }
    }
    return { config: e }
  },
  beforeMount() {
    // bs_error は 200 で来てしまうため自力でエラー画面に飛ばす
    if (this.bs_error) {
      this.$nuxt.error({statusCode: 400, message: this.bs_error.message}) // "400 Bad Request"
      return
    }
    if (this.blank_p(this.$route.query)) {
      this.ga_click("共有将棋盤")
    } else {
      this.ga_click("共有将棋盤●")
    }
  },
  computed: {
    meta() {
      if (this.config) {
        return {
          short_title: true,
          title: this.config.twitter_card_options.title,
          description: "リレー将棋・詰将棋の作成や公開・課題局面の作成や公開・対人戦向けオンライン盤共有などが可能です",
          og_description: this.config.twitter_card_options.description,
          og_image: this.config.twitter_card_options.image,
        }
      }
    }
  },
}
</script>

<style lang="sass">
</style>
