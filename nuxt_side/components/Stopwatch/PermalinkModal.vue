<template lang="pug">
.PermalinkModal.modal-card.mx-4(style="width: auto")
  .modal-card-head
    .modal-card-title パーマリンク
  .modal-card-body.px-5.py-5
    b-field(label="PCブックマーク用" custom-class="is-small" type="is-primary" message="現在の状態をドラッグでブクマするときに便利なリンク(タイトルとURLをペアでブクマできる)")
      b-button(expanded tag="a" :href="base.permalink_url") {{base.book_title}}
    b-field(label="ブラウザ移行用URL" custom-class="is-small" type="is-primary" message="このURLをコピーして他のブラウザに持っていくと今と同じ状態で再開できる")
      b-input(expanded readonly :value="base.permalink_url")
      p.control
        b-button(@click="clipboard_copy({text: base.permalink_url})" type="is-primary") コピー

  .modal-card-foot
    button.button(type="button" @click="close_handle") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "PermalinkModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.PermalinkModal
  tr:hover
    cursor: pointer
  tr > *
    border-width: 0
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
