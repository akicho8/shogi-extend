<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 局面の転送
  .modal-card-body
    p
      | 現在の局面を他の人に配ります
    p.has-text-grey.is-size-7
      | 自動で転送するようにしたので基本的に手動で実行する必要はありません (2021-11-23)
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.test_button.has-text-weight-normal(@click="test_handle" v-if="development_p") テスト
    b-button.sync_button(@click="sync_handle" type="is-danger") 転送する
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "ForceSyncModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sfx_play_click()
      this.$emit("close")
    },
    test_handle() {
      this.sfx_play_click()
      this.SB.force_sync("テスト転送")
    },
    sync_handle() {
      this.sfx_play_click()
      this.SB.force_sync_direct()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "./sass/support.sass"
.ForceSyncModal
  +modal_width(28rem)
  .modal-card-body
    padding: 1.5rem
    p:not(:first-child)
      margin-top: 0.75rem
</style>
