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
      title: this.page_title,
      meta: [
        { hid: "og:title",       property: "og:title",       content: this.page_title                                      },
        { hid: "og:image",       property: "og:image",       content: this.$config.MY_NUXT_URL + "/ogp/swars-users-key.png" },
        { hid: "og:description", property: "og:description", content: ""                                                   },
      ],
    }
  },
  computed: {
    page_title() {
      return `${this.$route.params.key} | 将棋ウォーズプレイヤー情報`
    },
  },
}
</script>

<style lang="sass">
.swars-users-key
</style>
