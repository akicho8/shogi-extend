<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title キーボード操作
  .modal-card-body
    table.table.is-narrow
      tr
        th.has-text-right p k Space
        td 開始 / 停止
      tr
        th.has-text-right o Enter
        td 正解
      tr
        th.has-text-right.has-text-right x
        td 不正解
      tr
        th.has-text-right z
        td 1つ前に戻す
      tr
        th.has-text-right r
        td 最後のタイムだけリセット
      tr
        th.has-text-right t
        td 最後の解答の正誤を反転する
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KeyboardModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.KeyboardModal
  +modal_width_auto
  tr > *
    border-width: 0
</style>
