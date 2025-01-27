<template lang="pug">
.SbShortcutModal.modal-card.box.has-text-left.is-size-7(@click="close_handle" style="width:auto")
  .has-text-weight-bold.simple_title
    | ショートカット
  table.modal-card-body.table.is-fullwidth.is-narrow
    tbody
      tr
        th 部屋に入る
        td
          b-tag(type="is-primary") i
      tr
        th 順番設定
        td
          b-tag(type="is-primary") o
      tr
        th 対局時計
        td
          b-tag(type="is-primary") c
      tr
        th チャットを開く
        td
          b-tag(type="is-primary") Enter
      tr
        th チャットを閉じる
        td
          b-tag(type="is-primary") Enter
          //- | or 空送信
      tr
        th 棋譜コピー
        td
          b-tag(type="is-primary") ⇧ c
      tr
        th 棋譜張り付け
        td
          b-tag(type="is-primary") ⇧ v
      tr
        th 局面編集・完了
        td
          b-tag(type="is-primary") ⇧ e
      tr
        th 設定
        td
          b-tag(type="is-primary") ,
      tr
        th これを開く
        td
          b-tag(type="is-primary") ?
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbShortcutModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.SB.shortcut_modal_close_handle()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SbShortcutModal
  .simple_title
    border-bottom: 1px solid $grey-lighter
    padding-bottom: 0.5rem
  .table
    margin-top: 0.5rem
    th, td
      vertical-align: middle
    th
      font-weight: normal
      text-align: right
      font-size: $size-7
      border-width: 0
    td
      border-width: 0

      display: flex
      align-items: center
      justify-content: flex-start
      gap: 0.25rem

  .tag
    font-weight: bold
</style>
