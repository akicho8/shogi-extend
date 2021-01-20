<template lang="pug">
client-only
  WbookIndexApp
</template>

<script>
export default {
  name: "wbook",
  // async asyncData({ $axios, query }) {
  //   const info = await $axios.$get("/api/wbook.json", {params: query})
  //   console.log(info)
  //   return { info }
  // },
  computed: {
    meta() {
      return {
        title: "問題集",
        description: "将棋の問題を解く力を競う対戦ゲーム",
        og_image_key: "wbook",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
