<template lang="pug">
client-only
  StyleEditor
</template>

<script>
import StyleEditor from "shogi-player/components/StyleEditor.vue"

export default {
  name: "style-editor",
  components: {
    StyleEditor,
  },
  computed: {
    meta() {
      return {
        title: "スタイルエディタ",
        description: "将棋盤のスタイルを試行錯誤する自分用ツール",
        og_image_key: "style-editor",
      }
    },
  },
}
</script>

<style lang="sass">
// $sp_assets_dir: "../node_modules/shogi-player/assets"
// @import "../node_modules/shogi-player/components/ShogiPlayer.sass"
</style>
