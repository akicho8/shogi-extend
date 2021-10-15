<template lang="pug">
.GalleryLemonNewForm.column.is-half.form_block
  b-tabs.mb-0(:expanded="false" type="is-boxed" v-model="base.form_tab_index" @input="sound_play('click')")
    b-tab-item(label="棋譜")
      GalleryLemonNewFormSource(:base="base")
    //- b-tab-item(label="オプション")
    //-   GalleryLemonNewFormOption(:base="base")
    b-tab-item(label="デザイン")
      GalleryLemonNewFormDesign(:base="base")
    b-tab-item(label="設定1")
      GalleryLemonNewFormPro1(:base="base")
    b-tab-item(label="設定2")
      GalleryLemonNewFormPro2(:base="base")
    b-tab-item(label="デバッグ" v-if="development_p")
      GalleryLemonNewFormDebug(:base="base")

  b-field.submit_field
    .control
      b-button.has-text-weight-bold(@click="base.submit_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GalleryLemonNewForm",
  mixins: [support_child],
  mounted() {
    this.base.body_focus()
  },
}
</script>

<style lang="sass">
.GalleryLemonNewForm
  .tab-content
    padding: 0

  .dropdown-item
    padding: 0.75rem
    // .media
    //   align-items: center // 縦中央寄せ
    .media-content
      overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

</style>
