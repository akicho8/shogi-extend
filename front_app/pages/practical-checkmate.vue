<template lang="pug">
client-only
  TsMasterApp(:config="config")
</template>

<script>
export default {
  name: "ts_master",
  async asyncData({ $axios, query }) {
    const config = await $axios.$get("/api/ts_master/time_records", {params: {config_fetch: true, ...query}})
    return { config }
  },
  computed: {
    meta() {
      return {
        title: "実戦詰将棋『一期一会』",
        description: "やねうら王の詰将棋500万問からﾗﾝﾀﾞﾑに出題",
        og_description: this.config.description,
        og_image_key: "practical-checkmate",
        twitter_card_is_small: true,
      }
    },
  },
}
</script>

<style lang="sass">
</style>
