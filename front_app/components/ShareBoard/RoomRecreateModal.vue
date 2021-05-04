<template lang="pug">
.modal-card.RoomRecreateModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 再接続

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    p
      | いったん退出して入室します
    p
      | 部屋に誰かいればその人の持っている棋譜の最後の局面に合わせます
    p
      | どうにもこうにもならなくなったときに実行してください

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" type="is-danger") 実行
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "RoomRecreateModal",
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
      this.base.room_recreate()
    },
    apply_handle() {
      this.sound_play("click")
      this.base.room_recreate()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.RoomRecreateModal
  +tablet
    width: 50ch
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
