<template lang="pug">
.SbShortcutModal.modal-card.box.has-text-left.is-size-7(@click="close_handle" style="width:auto")
  .has-text-weight-bold.simple_title.is-size-6
    | ショートカット
  .columns.is-multiline
    .column.is-half-desktop.is-half-tablet
      .sub_title 基本
      table.modal-card-body.table.is-fullwidth.is-narrow
        tbody
          tr
            th 棋譜の張り付け
            td
              b-tag(type="is-primary") ⇧ v
          tr
            th 棋譜コピー
            td
              b-tag(type="is-primary") ⇧ c
          tr
            th 短縮棋譜URLコピー
            td
              b-tag(type="is-primary") ⇧ u
          tr
            th 局面編集・完了
            td
              b-tag(type="is-primary") ⇧ e
          tr
            th
              | 棋譜の読み込み画面を開く
            td
              b-tag(type="is-primary") ⇧ r
          tr
            th 本譜に戻る
            td
              b-tag(type="is-primary") z

    .column.is-half-desktop.is-half-tablet
      .sub_title 対局時
      table.modal-card-body.table.is-fullwidth.is-narrow
        tbody
          tr
            th 入退室
            td
              b-tag(type="is-primary") 1
          tr
            th 順番設定
            td
              b-tag(type="is-primary") 2
              | or
              b-tag(type="is-primary") o
          tr
            th 対局時計
            td
              b-tag(type="is-primary") 3
              | or
              b-tag(type="is-primary") t
          tr
            th チャットを開く / 閉じる
            td
              b-tag(type="is-primary") Enter

    .column.is-half-desktop.is-half-tablet
      .sub_title 思考印
      table.modal-card-body.table.is-fullwidth.is-narrow
        tbody
          tr
            th 思考印を書く / 消す
            td
              b-tag(type="is-primary") 副ボタン
          tr
            th 思考印を書く / 消す
            td
              b-tag(type="is-primary") ⇧主ボタン
          tr
            th 思考印モードのトグル
            td
              b-tag(type="is-primary") m
    .column.is-half-desktop.is-half-tablet
      .sub_title その他
      table.modal-card-body.table.is-fullwidth.is-narrow
        tbody
          tr
            th サイドバーのトグル
            td
              b-tag(type="is-primary") /
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
@import "../sass/support.sass"
.SbShortcutModal
  +modal_max_width(640px)

  .simple_title
    // border-bottom: 1px solid $grey-lighter
    padding-bottom: 0.5rem

  .columns
    margin-top: 0rem

  +mobile
    padding: 1rem
    .columns
      margin: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem
    +tablet
      padding: 1.5rem

  .sub_title
    margin-top: 0.5rem
    border-bottom: 1px solid $grey-lighter
    +mobile
      margin-top: 1.2rem

  .table
    margin-top: 0.25rem
    th, td
      vertical-align: middle
    th
      width: 66%
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

.STAGE-development
  .SbShortcutModal
    .columns
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
    table
      border: 1px dashed change_color($danger, $alpha: 0.5)
    td
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
