<template lang="pug">
client-only
  SwarsBattleShow(:user_key="$route.params.key")
</template>

<script>
export default {
  name: "swars-battles-key",
  async asyncData({$axios, params, query}) {
    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?basic_fetch=1
    // http://0.0.0.0:4000/swars/battles/devuser1-Yamada_Taro-20200101_123401
    const info = await $axios.$get(`/w/${params.key}.json`, {params: {ogp_only: true, basic_fetch: true, ...query}})
    return { info }
  },
  head() {
    return {
      title: `将棋ウォーズバトル情報`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: `将棋ウォーズバトル情報` },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-battles-key.png" },
        { hid: "og:description", property: "og:description", content: ""},
      ],
    }
  },
}
</script>

<style lang="sass">
</style>
