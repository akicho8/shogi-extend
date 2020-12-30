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
        title: "符号の鬼",
        description: "将棋の符号を覚えるツールです",
        og_description: this.config.description,
        og_image_key: "checkmate",
        twitter_card_is_small: true,
      }
    },
  },
}
</script>

<style lang="sass">
</style>
