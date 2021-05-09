<template lang="pug">
ShareBoardApp(:config="config" v-if="config")
</template>

<script>
export default {
  name: "share-board",
  data() {
    return {
      config: null,
    }
  },
  fetch() {
    return this.$axios.$get("/api/share_board", {params: this.$route.query}).then(e => {
      // bs_error は 200 で来てしまうため自力でエラー画面に飛ばす FIXME: 自動で飛ばしたい
      if (e.bs_error) {
        this.$nuxt.error({statusCode: 400, message: e.bs_error.message}) // "400 Bad Request"
        return
      }
      this.config = e.config
    })
  },
  mounted() {
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
