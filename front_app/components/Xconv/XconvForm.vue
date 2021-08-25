<template lang="pug">
.XconvForm.column.is-half
  b-tabs.mb-0(expanded type="is-boxed" v-model="base.form_tab_index" @input="sound_play('click')")
    b-tab-item(label="棋譜")
      XconvForm1(:base="base")
    b-tab-item(label="オプション")
      XconvForm2(:base="base")
    b-tab-item(label="動画設定")
      XconvForm3(:base="base")
    b-tab-item(label="デバッグ" v-if="development_p")
      XconvForm4(:base="base")

  b-field.submit_field
    .control
      b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.XconvForm
  .tab-content
    padding: 0

  .one_block
    margin: 0
    padding: 0.8rem 0 1.2rem
    +tablet
      padding-left: 1.25rem
      padding-right: 1.25rem
      &:hover
        background-color: $white-ter

  .dropdown-item
    padding: 0.75rem
    .media
      align-items: center // 縦中央寄せ

  .submit_field
    margin: 0
    padding: 1rem 0
</style>
