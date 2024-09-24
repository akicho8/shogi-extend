<template lang="pug">
.SwShortcutModal.modal-card.box.has-text-left.is-size-7(@click="close_handle" style="width:auto")
  .has-text-weight-bold.simple_title
    | ショートカット
  table.modal-card-body.table.is-fullwidth.is-narrow
    tbody
      tr
        th 棋譜コピー
        td
          b-tag(type="is-primary") c
      tr
        th 棋譜コピー (KI2)
        td
          b-tag(type="is-primary") x
      tr
        th 一覧
        td
          b-tag(type="is-primary") 1
      tr
        th 開戦
        td
          b-tag(type="is-primary") 2
      tr
        th 中盤
        td
          b-tag(type="is-primary") 3
      tr
        th 終局
        td
          b-tag(type="is-primary") 4
      tr
        th 入力欄にフォーカス
        td
          b-tag(type="is-primary") /
      tr
        th 次のページに移動
        td
          b-tag(type="is-primary") n
      tr
        th 前のページに移動
        td
          b-tag(type="is-primary") p
      tr
        th 詳細を一気に開く
        td
          b-tag(type="is-primary") o
      tr
        th プレイヤー情報
        td
          b-tag(type="is-primary") i
      tr
        th カスタム検索
        td
          b-tag(type="is-primary") s
      //- tr
      //-   th チャットを開く
      //-   td
      //-     b-tag(type="is-primary") Enter
      //- tr
      //-   th チャットを閉じる
      //-   td
      //-     b-tag(type="is-primary") Enter
      //-     //- | or 空送信
      //- tr
      //-   th 棋譜コピー
      //-   td
      //-     b-tag(type="is-primary") ⇧ c
      //- tr
      //-   th 棋譜張り付け
      //-   td
      //-     b-tag(type="is-primary") ⇧ v
      //- tr
      //-   th 設定
      //-   td
      //-     b-tag(type="is-primary") ,
      tr
        th これを開く
        td
          b-tag(type="is-primary") ?
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SwShortcutModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.APP.shortcut_modal_close_handle()
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.SwShortcutModal
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
