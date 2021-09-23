<template lang="pug">
.KiwiLemonNewForm.column.is-half
  b-tabs.mb-0(:expanded="false" type="is-boxed" v-model="base.form_tab_index" @input="sound_play('click')")
    b-tab-item(label="棋譜")
      KiwiLemonNewFormSource(:base="base")
    //- b-tab-item(label="オプション")
    //-   KiwiLemonNewFormOption(:base="base")
    b-tab-item(label="デザイン")
      KiwiLemonNewFormDesign(:base="base")
    b-tab-item(label="設定1")
      KiwiLemonNewFormPro1(:base="base")
    b-tab-item(label="設定2")
      KiwiLemonNewFormPro2(:base="base")
    b-tab-item(label="デバッグ" v-if="development_p")
      KiwiLemonNewFormDebug(:base="base")

  b-field.submit_field
    .control
      b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary" expanded) 実行
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.KiwiLemonNewForm
  .tab-content
    padding: 0

  .one_block
    margin: 0
    padding: 0.8rem 0 1.2rem
    &.body_field
      padding: 1.0rem
    +tablet
      padding-left: 1.25rem
      padding-right: 1.25rem
      &:hover
        background-color: $white-ter

  .dropdown-item
    padding: 0.75rem
    // .media
    //   align-items: center // 縦中央寄せ
    .media-content
      overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

  .submit_field
    margin: 0
    padding: 1rem 0
</style>
