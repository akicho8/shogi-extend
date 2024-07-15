<template lang="pug">
client-only
  XyMasterApp(:config="config")
</template>

<script>
export default {
  name: "xy",
  async asyncData({ $axios, query }) {
    const config = await $axios.$get("/api/xy_master/time_records", {params: {config_fetch: true, ...query}})
    return { config }
  },
  computed: {
    meta() {
      return {
        title: "符号の鬼",
        description: "将棋の符号を覚えるツールです",
        og_description: this.config.description,
        og_image_key: "xy",
        og_card_size: "small",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
