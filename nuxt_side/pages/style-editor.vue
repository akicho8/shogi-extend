<template lang="pug">
client-only
  .page-style-editor
    StyleEditor
    b-button.close_button(icon-left="chevron-left" @click="back_handle" type="is-text")
</template>

<script>
import StyleEditor from "shogi-player/components/StyleEditor.vue"

export default {
  name: "page-style-editor",
  components: {
    StyleEditor,
  },
  methods: {
    back_handle() {
      this.sound_play_click()
      this.back_to()
    },
  },
  mounted() {
    this.ga_click("スタイルエディタ")
  },
  computed: {
    meta() {
      return {
        title: "スタイルエディタ",
        description: "将棋盤のスタイルをいじくるツール",
        og_image_key: "style-editor",
      }
    },
  },
}
</script>

<style lang="sass">
.page-style-editor
  .close_button
    position: absolute
    top: 0
    left: 0
</style>
