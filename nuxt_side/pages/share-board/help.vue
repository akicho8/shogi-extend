<template lang="pug">
QuickScriptView(qs_group_key="chore" qs_page_key="documentation" :qs_override_params="{md_key: 'share_board'}")
</template>

<script>
export default {
  name: "share-board-usage",
  computed: {
    meta() {
      return {
        title: ["使い方", "共有将棋盤"],
        description: "リレー将棋・詰将棋の作成や公開・課題局面の作成や公開・対人戦向けオンライン盤共有などが可能です",
        og_image_key: "share-board",
      }
    }
  },
}
</script>
