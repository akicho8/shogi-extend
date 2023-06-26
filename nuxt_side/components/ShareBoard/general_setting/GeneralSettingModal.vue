<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 設定
  .modal-card-body
    //- b-tabs(type="is-boxed" expanded size="is-small" v-model="main_tab_index" position="is-centered")
    //-   b-tab-item(label="日付")
    //-   b-tab-item(label="戦法")

    .columns.is-multiline
      template(v-for="m in GeneralSettingInfo.values")
        .column.is-half-tablet
          SimpleRadioButtons(
            :base="base"
            :model_name="m.param_info.relation"
            :var_name="m.key"
            :permanent_mark_append="m.param_info.permanent"
            custom-class="is-small"
            element_size="is-small"
            )
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
import { support_child   } from "../support_child.js"
import { GeneralSettingInfo } from "../models/general_setting_info.js"

export default {
  name: "GeneralSettingModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
  },
  computed: {
    GeneralSettingInfo() { return GeneralSettingInfo },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.GeneralSettingModal
  +modal_max_width(800px)
  .modal-card-body
    padding: 1.75rem
    .field:not(:first-child)
      margin-top: 1.25rem
</style>
