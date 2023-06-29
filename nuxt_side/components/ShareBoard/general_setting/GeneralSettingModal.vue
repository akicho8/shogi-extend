<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 設定
  .modal-card-body
    b-tabs(type="is-boxed" size="is-small" v-model="tab_index" @input="$sound.play_click()")
      template(v-for="e in TheSb.SettingCategoryInfo.values")
        b-tab-item(:label="e.name")
    .tab_content
      .columns.form_block.is-multiline.is-variable.is-0(:key="TheSb.setting_category_info.key")
        template(v-for="item in TheSb.setting_category_info.list.values")
          .column(:class="item.column_class || 'is-12-tablet'")
            SimpleRadioButtonsWrapper(:item="item")
    .notification.is-warning.is-light.is-size-7.mt-3
      ul
        li どれも初期値のままにしといた方がいい
        li
          span.has-text-danger ＊
          | がついているものはブラウザに保存する
        li 反則などは順番設定で他者から上書きされるのでここで設定してもあんま意味ない

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
export default {
  name: "GeneralSettingModal",
  inject: ["TheSb"],
  data() {
    return {
      tab_index: this.TheSb.setting_category_info.code,
    }
  },
  watch: {
    tab_index(v) { this.TheSb.setting_category_key = this.TheSb.SettingCategoryInfo.fetch(v).key },
  },
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
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
