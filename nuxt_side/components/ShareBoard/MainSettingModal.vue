<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 設定
  .modal-card-body
    .columns.is-multiline
      //- SimpleRadioButtons
      template(v-for="m in MainSettingInfo.values")
        .column.is-half-tablet
          b-field(:class="m.key" custom-size="is-small" :label="base[m.model].field_label" :message="base[m.model].field_message")
            template(v-for="e in base[m.model].values")
              b-radio-button(:class="e.key" @input="sound_play('click')" size="is-small" v-model="base[m.key]" :native-value="e.key" :type="e.type")
                | {{e.name}}
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
</template>

<script>
import { support_child   } from "./support_child.js"
import { MainSettingInfo } from "./models/main_setting_info.js"

export default {
  name: "MainSettingModal",
  mixins: [support_child],
  methods: {
    close_handle() {
      this.sound_play("click")
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
