<template lang="pug">
.KeyboardModal.modal-card(style="width: auto")
  header.modal-card-head
    p.modal-card-title キーボード操作
  section.modal-card-body
    table.table
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
    button.button(type="button" @click="$emit('close')") 閉じる
</template>

<script>
export default {
  name: "KeyboardModal",
  props: {
    base: { type: Object, required: true },
  },
  computed: {
    rows() {
      return this.base.memento_list.slice().reverse()
    },
  },
}
</script>

<style lang="sass">
.KeyboardModal
  tr:hover
    cursor: pointer
  .modal-card-foot
    justify-content: flex-end
    .button
      font-weight: bold
</style>
