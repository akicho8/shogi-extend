<template lang="pug">
client-only
  SwarsBattleIndex
</template>

<script>
export default {
  name: "swars-search",
  computed: {
    meta() {
      return {
        title: [this.$route.query.query, "将棋ウォーズ棋譜検索"],
        description: "ウォーズの棋譜をぴよ将棋やKENTOで開いたりクリップボード経由で外部アプリに渡すような使い方ができます",
        og_image_key: "swars-search",
      }
    },
  },
}
</script>
