<template lang="pug">
client-only
  .adapter
    AdapterApp(:config="config")
</template>

<script>
export default {
  name: "adapter",
  head() {
    return {
      title: "なんでも棋譜変換",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "なんでも棋譜変換"                             },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/adapter.png" },
        { hid: "og:description", property: "og:description", content: "将棋倶楽部24や掲示板などで見かける棋譜を外部アプリへ橋渡ししたり、検証・正規化・相互変換・印刷ができます" },
      ],
    }
  },
  async asyncData({ $axios, query }) {
    const config = await $axios.$get("/x.json", {params: {config_fetch: true, ...query}})
    return { config }
  },
}
</script>

<style lang="sass">
.adapter
</style>
