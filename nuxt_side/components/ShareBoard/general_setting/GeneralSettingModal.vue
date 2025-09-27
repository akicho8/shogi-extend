<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 設定
    b-button.is-marginless(size="is-small" @click="SB.general_setting_reset_handle") リセット
  .modal-card-body
    //- https://buefy.org/documentation/tabs
    b-tabs(type="is-boxed" size="is-small" v-model="tab_index" @input="input_handle" expanded)
      template(v-for="e in SB.SettingCategoryInfo.values")
        b-tab-item(:label="e.name")
    .tab_content
      .columns.form_block.is-multiline.is-variable.is-0(:key="SB.setting_category_info.key")
        template(v-for="item in SB.setting_category_info.list.values")
          .column(:class="item.column_class || 'is-12-tablet'")
            SimpleRadioButtonWrapper(:item="item")
    .notification.is-warning.is-light.is-size-7.mt-3
      ul
        li
          span.has-text-danger ＊
          | がついているものはブラウザに保存する

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "GeneralSettingModal",
  mixins: [support_child],
  data() {
    return {
      tab_index: this.SB.setting_category_info.code,
    }
  },
  watch: {
    tab_index(v) { this.SB.setting_category_key = this.SB.SettingCategoryInfo.fetch(v).key },
  },
  methods: {
    close_handle() {
      this.SB.general_setting_modal_close_handle()
    },
    input_handle(index) {
      this.sfx_click()
      this.SB.sb_talk(this.SB.SettingCategoryInfo.fetch(index).name)
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.GeneralSettingModal
  +modal_width(800px)
  +modal_height(700px)
  +modal_height_if_mobile(60vh)
  +bulma_columns_vertical_minus_margin_clear

  // .modal-card
  //   overflow: hidden
  // .modal-card-body
  //   overflow: hidden

  .modal-card-body
    padding: 1rem
    .b-tabs, .tab-content
      padding: 0
    .b-tabs
      margin-top: 0
      margin-bottom: 0
    .tab_content
      margin-top: 1.25rem

.STAGE-development
  .GeneralSettingModal
    .column
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .field, .notification
      border: 1px dashed change_color($danger, $alpha: 0.5)
</style>
