<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 使い方
    b-tooltip(position="is-left" label="パーマリンク")
      a.permalink(href="/animation-export/help" target="_blank")
        b-icon(icon="link")
  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    XconvHelpBody
  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvHelpModal",
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
.XconvHelpModal
  .modal-card-body
    padding: 0

  +mobile
    .animation-content
      max-width: 96vw
      .modal-card
        max-height: 80vh
  +tablet
    .animation-content
      max-width: 640px // $buefy.modal.open({width: 640}) 相当
      .modal-card
        width: auto    // buefyのデモを参考

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
