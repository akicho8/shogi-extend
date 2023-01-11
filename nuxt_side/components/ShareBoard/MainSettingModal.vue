<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 設定
  .modal-card-body
    .columns.is-multiline
      template(v-for="m in MainSettingInfo.values")
        .column.is-half-tablet
          SimpleRadioButtons(:base="base" :model_name="m.param_info.relation" :var_name="m.key" :permanent_mark_append="m.param_info.permanent")
    .columns.is-centered
      .column
        .notification.is-warning.is-light.is-size-7
          ul
            li どれも初期値のままにしといた方がいい
            li <b>*</b> がついているものはブラウザに保存する

  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child   } from "./support_child.js"
import { MainSettingInfo } from "./models/main_setting_info.js"

export default {
  name: "MainSettingModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
  computed: {
    MainSettingInfo() { return MainSettingInfo },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.MainSettingModal
  +modal_max_width(800px)
  .modal-card-body
    padding: 1.75rem
    .field:not(:first-child)
      margin-top: 1.25rem
</style>
