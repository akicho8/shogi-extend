<template lang="pug">
.StopwatchKeyboardModal.modal-card.mx-4(style="width: auto")
  header.modal-card-head
    p.modal-card-title キーボード操作
  section.modal-card-body
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
  footer.modal-card-foot
    button.button(type="button" @click="close_handle") 閉じる
</template>

<script>
import { support } from "./support.js"

export default {
  name: "StopwatchKeyboardModal",
  mixins: [
    support,
  ],
  props: {
    base: { type: Object, required: true },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
.StopwatchKeyboardModal
  tr:hover
    cursor: pointer
  tr > *
    border-width: 0
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
