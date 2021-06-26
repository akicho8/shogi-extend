<template lang="pug">
//- (style="width:auto")
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    .columns.is-multiline
      template(v-for="m in MainSettingInfo.values")
        .column.is-half-tablet
          b-field(:class="m.key" custom-size="is-small" :label="base[m.model].field_label" :message="base[m.model].field_message")
            template(v-for="e in base[m.model].values")
              b-radio-button(:class="e.key" @input="sound_play('click')" size="is-small" v-model="base[m.key]" :native-value="e.key" :type="e.type")
                | {{e.name}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.test_button(@click="test_handle" v-if="development_p") 追加
    //- b-button.send_button(@click="send_handle" type="is-primary") 送信
</template>

<script>
import { support_child   } from "./support_child.js"
import { MainSettingInfo } from "./main_setting_info.js"

export default {
  name: "MainSettingModal",
  mixins: [
    support_child,
  ],
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    // test_handle() {
    //   this.sound_play("click")
    //   this.base.ml_add_test()
    // },
    // send_handle() {
    //   if (this.present_p(this.base.message_body2)) {
    //     this.sound_play("click")
    //     this.base.message_share({message: this.base.message_body2})
    //     this.base.message_body2 = ""
    //     this.input_focus()
    //   }
    // },
    // input_focus() {
    //   this.desktop_focus_to(this.$refs.message_input_tag)
    // },
  },
  computed: {
    MainSettingInfo() { return MainSettingInfo },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.MainSettingModal
  // +tablet
  //   width: 100%
  .modal-card-body
    padding: 1.75rem
    .field:not(:first-child)
      margin-top: 1.25rem

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
