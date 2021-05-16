<template lang="pug">
.modal-card.MainSettingModal(style="width:auto")
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field.ctrl_mode(label="対局時計動作時の盤面下のコントローラー")
      b-radio-button.is_ctrl_mode_hidden(v-model="base.ctrl_mode" native-value="is_ctrl_mode_hidden") 誤タップしないように隠す
      b-radio-button.is_ctrl_mode_visible(v-model="base.ctrl_mode" native-value="is_ctrl_mode_visible") 表示したままにする
    b-field.yomiage_mode(label="部屋内で検討時の棋譜読み上げ")
      b-radio-button.is_yomiage_mode_on(v-model="base.yomiage_mode" native-value="is_yomiage_mode_on") する
      b-radio-button.is_yomiage_mode_off(v-model="base.yomiage_mode" native-value="is_yomiage_mode_off") しない
    b-field.sync_mode(label="同期方法" v-if="development_p")
      b-radio-button.is_sync_mode_on(v-model="base.sync_mode" native-value="is_sync_mode_hard") 完全同期
      b-radio-button.is_sync_mode_off(v-model="base.sync_mode" native-value="is_sync_mode_soft") 着手
    b-field.debug_mode(label="デバッグモード")
      b-radio-button.is_debug_mode_off(v-model="base.debug_mode" native-value="is_debug_mode_off") OFF
      b-radio-button.is_debug_mode_on(v-model="base.debug_mode" native-value="is_debug_mode_on") ON

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
