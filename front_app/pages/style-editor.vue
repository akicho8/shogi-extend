<template lang="pug">
client-only
  //- StyleEditor(v-bind="style_editor_params")
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
        description: "将棋盤のスタイルをいじくるツール",
        og_image_key: "style-editor",
      }
    },
    // style_editor_params() {
    //   return {
    //     kifu_body: this.$route.query.body,
    //     player_info: this.player_info,
    //   }
    // },
    // player_info() {
    //   const { white, black } = this.$route.query
    //   if (white || black) {
    //     return {
    //       black: { name: black, },
    //       white: { name: white, },
    //     }
    //   }
    // },
  },
}
</script>

<style lang="sass">
</style>
