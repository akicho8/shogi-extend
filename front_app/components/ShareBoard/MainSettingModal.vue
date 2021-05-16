<template lang="pug">
.modal-card.MainSettingModal(style="width:auto")
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field(label="対局時計が動作しているとき盤面下のコントローラーを")
      b-radio-button(size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_hidden") 誤タップしないように隠す
      b-radio-button(size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_visible") 表示したままにする
    b-field(label="デバッグモード")
      b-radio-button(size="is-small" v-model="base.debug_mode" native-value="is_debug_mode_off") OFF
      b-radio-button(size="is-small" v-model="base.debug_mode" native-value="is_debug_mode_on") ON

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.test_button(@click="test_handle" v-if="development_p") 追加
    //- b-button.send_button(@click="send_handle" type="is-primary") 送信
</template>

<script>
import { support_child } from "./support_child.js"

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
}
</script>

<style lang="sass">
@import "support.sass"
.MainSettingModal
  // +tablet
  //   width: 64rem
  .modal-card-body
    padding: 1.5rem
    .field:not(:first-child)
      margin-top: 1.25rem

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
