<template lang="pug">
.WkbkBookShowKbShortcutModal.modal-card.box.has-text-left(@click="delete_click_handle" style="width:auto")
  .has-text-weight-bold.simple_title.is-size-6.pb-3
    | キーボードショートカット
  table.modal-card-body.table.is-fullwidth.mt-3.mb-0
    tbody
      tr
        th
          b-icon(:icon="base.AnswerKindInfo.fetch('correct').icon")
        td
          b-tag(type="is-primary") O
          b-tag.ml-1(type="is-primary") ENTER
      tr
        th
          b-icon(:icon="base.AnswerKindInfo.fetch('mistake').icon")
        td
          b-tag(type="is-primary") X
      tr
        th 終了
        td
          b-tag(type="is-primary") ESC
          b-tag.ml-1(type="is-primary") Q
      tr
        th 1つ前に戻る
        td
          b-tag(type="is-primary") BACKSPACE
      tr
        th ｷｰﾎﾞｰﾄﾞｼｮｰﾄｶｯﾄ
        td
          b-tag(type="is-primary") ?
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowKbShortcutModal",
  mixins: [support_child],
  methods: {
    delete_click_handle() {
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowKbShortcutModal
  .simple_title
    border-bottom: 1px solid $grey-lighter
  .table
    th, td
      vertical-align: middle
    th
      font-weight: normal
      text-align: right
      border-width: 0
      font-size: $size-7
    td
      text-align: left
      border-width: 0
  .tag
    font-weight: bold
</style>
