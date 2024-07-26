<template lang="pug">
client-only
  SwarsCustomSearchApp(:xi="xi")
</template>

<script>
export default {
  name: "swars-custom-search",
  async asyncData({ $axios, query }) {
    const xi = await $axios.$get("/api/swars/custom_search_setup.json", {params: query})
    return { xi }
  },
  computed: {
    meta() {
      return {
        title: ["カスタム検索", "将棋ウォーズ棋譜検索"],
        description: "",
        og_image_key: "swars-custom-search",
      }
    },
  },
}
</script>
