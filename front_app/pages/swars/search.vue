<template lang="pug">
client-only
  .swars-search
    SwarsSearchApp(:config="config")
</template>

<script>
export default {
  name: "swars-search",
  head() {
    return {
      title: "将棋ウォーズ棋譜検索",
      meta: [
        { hid: "og:title",       property: "og:title",       content: "将棋ウォーズ棋譜検索"                            },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                             },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-search.png" },
        { hid: "og:description", property: "og:description", content: ""                                                },
      ],
    }
  },
  watchQuery: true,
  // watch: {
  //   "$route.query": async function(v) {
  //     this.$buefy.toast.open({message: `watch query: ${JSON.stringify(v)}`, queue: false})
  //     this.config = await this.$axios.$get("/w.json", {params: v})
  //   },
  // },
  async asyncData({ $axios, query }) {
    // http://0.0.0.0:4000/swars/search?query=devuser1
    // http://0.0.0.0:3000/w.json?query=devuser1
    console.log("asyncData")
    const config = await $axios.$get("/w.json", {params: query})
    return { config }
  },
}
</script>

<style lang="sass">
.swars-search
  .section
    padding-top: 1.3rem
</style>
