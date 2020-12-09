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
  computed: {
    meta() {
      return {
        title: [this.$route.params.key, "将棋ウォーズプレイヤー情報"],
        og_image_key: "swars-users-key",
      }
    },
  },
}
</script>

<style lang="sass">
.swars-users-key
</style>
