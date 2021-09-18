<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | 使い方
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(href="/movie-factory/help" target="_blank")
        b-icon(icon="link")
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body
    XmovieHelpBody
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XmovieHelpModal",
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
.XmovieHelpModal
  +modal_max_width(800px)

  .modal-card-body
    padding: 0
</style>
