<template lang="pug">
.modal-card.GeneralHelpModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 使い方
    b-tooltip(position="is-left" label="パーマリンク")
      a(href="/share-board/help" target="_blank")
        b-icon(icon="link")
  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    ShareBoardHelpBody
  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GeneralHelpModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.GeneralHelpModal
  height: 80vh

  // +tablet
  //   width: 64rem
  .modal-card-body
    padding: 0

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
