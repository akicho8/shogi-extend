<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title パーマリンク
  .modal-card-body
    b-field(label="PCブックマーク用" custom-class="is-small" type="is-primary" message="現在の状態をドラッグでブクマするときに便利なリンク(タイトルとURLをペアでブクマできる)")
      b-button(expanded tag="a" :href="base.permalink_url") {{base.book_title}}
    b-field(label="ブラウザ移行用URL" custom-class="is-small" type="is-primary" message="このURLをコピーして他のブラウザに持っていくと今と同じ状態で再開できる")
      b-input(expanded readonly :value="base.permalink_url")
      p.control
        b-button(@click="clipboard_copy(base.permalink_url)" type="is-primary") コピー
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "PermalinkModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sfx_play_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.PermalinkModal
  +modal_width(512px)
</style>
