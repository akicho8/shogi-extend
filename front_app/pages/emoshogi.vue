<template lang="pug">
client-only
  EmoxApp
</template>

<script>
export default {
  name: "emox",
  // async asyncData({ $axios, query }) {
  //   const info = await $axios.$get("/api/emox.json", {params: query})
  //   return { info }
  // },
  computed: {
    meta() {
      return {
        title: "エモ将棋",
        description: "将棋の対人戦ができる",
        og_image_key: "emox",
      }
    },
  },
}
</script>

<style lang="sass">
</style>
