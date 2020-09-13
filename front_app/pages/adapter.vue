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
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                          },
        { hid: "og:image",       property: "og:image",       content: this.$config.BASE_URL_OGP + "/ogp/adapter.png" },
        { hid: "og:description", property: "og:description", content: "将棋倶楽部24や掲示板などで見かける棋譜を外部アプリへ橋渡ししたり、検証・正規化・相互変換・印刷ができます" },
      ],
    }
  },
  async asyncData({ $axios }) {
    // proxy してないのになぜ呼ばれる？？？
    const config = await $axios.$get("/x.json", {params: {config_fetch: true}})
    return { config }
  },
}
</script>

<style lang="sass">
.adapter
</style>
