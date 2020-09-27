<template lang="pug">
client-only
  FormalSheetShow(:info="info")
</template>

<script>
export default {
  name: "swars-formal-sheets-key",
  async asyncData({$axios, params, query}) {
    // http://0.0.0.0:3000/w/devuser1-Yamada_Taro-20200101_123401.json?formal_sheet=1
    // http://0.0.0.0:4000/swars/formal-sheets/devuser1-Yamada_Taro-20200101_123401
    const info = await $axios.$get(`/w/${params.key}.json`, {params: {formal_sheet: true, ...query}})
    return { info }
  },
  head() {
    return {
      title: this.info.html_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.info.html_title },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-formal-sheets-key.png" },
        { hid: "og:description", property: "og:description", content: ""},
      ],
    }
  },
}
</script>

<style lang="sass">
.swars-formal-sheets-key
</style>
