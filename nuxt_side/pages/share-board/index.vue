<template lang="pug">
client-only
  //- client-only しないと SbApp の beforeMount が呼ばれる前に render されたりともうめちくちゃなことになる
  SbApp(:config="config" v-if="config")
</template>

<script>
export default {
  name: "share-board",
  async asyncData({ $axios, params, query, error }) {
    try {
      const config = await $axios.$get("/api/share_board.json", {params: query})
      return { config: config }
    } catch (e) {
      error({statusCode: e.response?.status ?? 500, message: e.message, __RAW_ERROR_OBJECT__: e, __RESPONSE_DATA__: e.response?.data})
    }
  },
  computed: {
    meta() {
      if (this.config) {
        return {
          page_title_only: true,
          title: this.config.twitter_card_options.title,
          description: "リレー将棋・詰将棋の作成や公開・課題局面の作成や公開・対人戦向けオンライン盤共有などが可能です",
          og_description: this.config.twitter_card_options.description,
          og_image_path: this.config.twitter_card_options.image,
        }
      }
    }
  },
}
</script>
