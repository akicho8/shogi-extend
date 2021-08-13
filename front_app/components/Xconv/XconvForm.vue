<template lang="pug">
.XconvForm.column.is-half
  b-tabs.mb-0(expanded type="is-boxed" v-model="base.form_tab_index" @input="sound_play('click')")
    b-tab-item(label="メイン")
      XconvForm1(:base="base")
    b-tab-item(label="オプション")
      XconvForm2(:base="base")
    b-tab-item(label="動画設定")
      XconvForm3(:base="base")

  b-field.submit_field
    .control
      b-button.has-text-weight-bold(@click="base.submit_handle" type="is-danger" icon-left="rocket-launch") 実行
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

  .main_field
    margin: 0
    padding: 1rem 0
    +tablet
      padding: 1rem 1.25rem
      &:hover
        background-color: $white-ter

  .submit_field
    margin: 0
    padding: 1rem 0
</style>
