<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | よくある質問 (FAQ)
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(href="/swars/search/help" target="_blank")
        b-icon(icon="link")
  .modal-card-body
    SwarsBattleIndexHelpBody
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsBattleIndexHelpModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.SwarsBattleIndexHelpModal
  +modal_width(800px)
  .modal-card-body
    padding: 0
</style>
