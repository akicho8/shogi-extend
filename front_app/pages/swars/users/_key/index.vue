<template lang="pug">
client-only
  .swars-users-key
    SwarsUserShow
</template>

<script>
export default {
  name: "swars-users-key",
  // async asyncData({ $axios, params, query}) {
  //   // http://0.0.0.0:3000/w.json?query=devuser1&format_type=user
  //   // http://0.0.0.0:4000/swars/users/devuser1
  //   const info = await $axios.$get("/w.json", {params: {query: params.key, format_type: "user", ...query}})
  //   return { info }
  // },
  head() {
    return {
      title: `将棋ウォーズプレイヤー情報`,
      meta: [
        { hid: "og:title",       property: "og:title",       content: `将棋ウォーズプレイヤー情報` },
        { hid: "twitter:card",   property: "twitter:card",   content: "summary_large_image"                                },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_OGP_URL + "/ogp/swars-users-key.png" },
        { hid: "og:description", property: "og:description", content: ""},
      ],
    }
  },
}
</script>

<style lang="sass">
.swars-users-key
</style>
