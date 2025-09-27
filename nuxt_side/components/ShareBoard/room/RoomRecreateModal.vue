<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 再起動
  .modal-card-body
    p
      | 音が出ないときに試すと直ることがあります
    p
      | いったん退室してブラウザをリロードして再度入室します
    p
      | 部屋に他の人がいれば、その人の持っている最後の局面に合わせます
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.test_button(@click="test_handle" v-if="development_p") テスト
    b-button.apply_button(@click="apply_handle" type="is-danger") 実行
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "RoomRecreateModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    test_handle() {
      this.sfx_click()
      this.SB.room_recreate()
    },
    apply_handle() {
      this.sfx_click()
      this.SB.room_recreate()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.RoomRecreateModal
  +modal_width(26rem)
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
</style>
