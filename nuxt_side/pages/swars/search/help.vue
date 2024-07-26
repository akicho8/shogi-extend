<template lang="pug">
QuickScriptView(qs_group_key="swars" qs_page_key="documentation")
</template>

<script>
export default {
  name: "swars-search-help",
  computed: {
    meta() {
      return {
        title: ["使い方", "将棋ウォーズ棋譜検索"],
        description: "",
        og_image_key: "swars-search",
      }
    }
  },
}
</script>
