<template lang="pug">
client-only
  WkbkArticleIndexApp
</template>

<script>
export default {
  name: "library-articles",
  // async asyncData({ $axios, query }) {
  //   const info = await $axios.$get("/api/wkbk.json", {params: query})
  //   console.log(info)
  //   return { info }
  // },
  computed: {
    meta() {
      return {
        title: "問題集",
        description: "将棋の問題を解く力を競う対戦ゲーム",
        og_image_key: "wkbk",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
