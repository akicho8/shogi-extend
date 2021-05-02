<template lang="pug">
.modal-card.ForceSyncModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 現在の局面を同期する

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    | あああああああああああああああああ

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.send_button(@click="sync_handle" type="is-primary") 同期する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ForceSyncModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.force_sync()
    },
    sync_handle() {
      this.sound_play("click")
      this.base.force_sync()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ForceSyncModal
  +desktop
    width: 40ch
  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
