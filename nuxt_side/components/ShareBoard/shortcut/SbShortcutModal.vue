<template lang="pug">
.SbShortcutModal.modal-card.box.has-text-left(@click="close_handle" style="width:auto")
  .sc_main_title
    | ショートカット
  .columns.is-multiline.is-variable.is-0-mobile.is-3-tablet.is-3-desktop.is-3-widescreen.is-3-fullhd
    .column.is-half-desktop.is-half-tablet
      .sc_sub_title 基本
      .sc_table
        .sc_item
          .sc_label 棋譜の張り付け
          .sc_buttons
            b-tag(type="is-primary") ⇧ v
        .sc_item
          .sc_label 棋譜の入力
          .sc_buttons
            b-tag(type="is-primary") ⇧ r
        .sc_item
          .sc_label 棋譜コピー (KIF)
          .sc_buttons
            b-tag(type="is-primary") c
        .sc_item
          .sc_label 局面コピー (BOD)
          .sc_buttons
            b-tag(type="is-primary") b
        .sc_item
          .sc_label 棋譜ダウンロード (KIF)
          .sc_buttons
            b-tag(type="is-primary") s
        .sc_item
          .sc_label 短縮した棋譜URLコピー
          .sc_buttons
            b-tag(type="is-primary") u
        .sc_item
          .sc_label そのままの棋譜URLコピー
          .sc_buttons
            b-tag(type="is-primary") l
        .sc_item
          .sc_label 局面編集 / 完了
          .sc_buttons
            b-tag(type="is-primary") ⇧ e

    .column.is-half-desktop.is-half-tablet
      .sc_sub_title 対局
      .sc_table
        .sc_item
          .sc_label 入退室
          .sc_buttons
            b-tag(type="is-primary") 1
        .sc_item
          .sc_label 順番設定
          .sc_buttons
            b-tag(type="is-primary") 2
            | or
            b-tag(type="is-primary") o
        .sc_item
          .sc_label 対局時計 起動
          .sc_buttons
            b-tag(type="is-primary") 3
            | or
            b-tag(type="is-primary") t
        .sc_item
          .sc_label 一時停止 / 再開
          .sc_buttons
            b-tag(type="is-primary") p
        .sc_item
          .sc_label チャットを開く / 閉じる
          .sc_buttons
            b-tag(type="is-primary") Enter
        .sc_item
          .sc_label 本譜に戻る
          .sc_buttons
            b-tag(type="is-primary") z
        .sc_item
          .sc_label 初期配置に戻す
          .sc_buttons
            b-tag(type="is-primary") 0
        .sc_item
          .sc_label 手合割
          .sc_buttons
            b-tag(type="is-primary") i

    .column.is-half-desktop.is-half-tablet
      .sc_sub_title 思考印
      .sc_table
        .sc_item
          .sc_label 思考印を書く / 消す
          .sc_buttons
            b-tag(type="is-primary") 副ボタン
        .sc_item
          .sc_label 思考印モードのトグル
          .sc_buttons
            b-tag(type="is-primary") m
    .column.is-half-desktop.is-half-tablet
      .sc_sub_title その他
      .sc_table
        .sc_item
          .sc_label サイドバーのトグル
          .sc_buttons
            b-tag(type="is-primary") /
        .sc_item
          .sc_label 設定
          .sc_buttons
            b-tag(type="is-primary") ,
        .sc_item
          .sc_label これを開く
          .sc_buttons
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
  +modal_max_width(512px)

  ////////////////////////////////////////////////////////////////////////////////

  padding: 1.5rem
  +mobile
    padding: 1rem
    .columns
      margin: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

  ////////////////////////////////////////////////////////////////////////////////

  .sc_main_title
    font-weight: bold

  .columns
    margin-top: 0rem
    font-size: $size-7
    .column
      .sc_sub_title
        font-weight: bold
        margin-top: 0.5rem
        border-bottom: 1px solid $grey-lighter
        +mobile
          margin-top: 1.2rem
      .sc_table
        margin-top: 0.25rem
        .sc_item
          display: flex
          align-items: center
          justify-content: space-between
          padding: 0.15rem 0
          .sc_label
            font-weight: normal
            font-size: $size-7
          .sc_buttons
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
