<template lang="pug">
client-only
  ActbApp(:info="info")
</template>

<script>
export default {
  name: "actb",
  async asyncData({ $axios, query }) {
    const info = await $axios.$get("/api/actb.json", {params: query})
    return { info }
  },
  computed: {
    meta() {
      return {
        title: "将棋トレーニングバトル",
        description: "将棋の問題を解く力を競う対戦ゲーム",
        og_image_key: "actb",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
