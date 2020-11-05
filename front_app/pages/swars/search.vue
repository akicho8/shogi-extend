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
        description: "将棋ウォーズの棋譜をぴよ将棋・KENTO・その他の外部アプリに橋渡しします。プレイヤーの段級位毎の勝率なども調べられます",
        og_image_key: "swars-search",
      }
    },
  },
}
</script>
