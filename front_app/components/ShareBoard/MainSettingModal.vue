<template lang="pug">
//- (style="width:auto")
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field.ctrl_mode(custom-size="is-small" label="対局時のコントローラー表示" message="時計が動いているときを対局中と想定している。誤タップが気になる場合は隠そう")
      b-radio-button.is_ctrl_mode_visible(@input="sound_play('click')" size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_visible") 表示
      b-radio-button.is_ctrl_mode_hidden(@input="sound_play('click')" size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_hidden") 隠す

    b-field.yomiage_mode(custom-size="is-small" label="検討時の棋譜読み上げ" message="時計を設置していないときを検討時と想定している。検討に集中したいときは「しない」にしよう")
      b-radio-button.is_yomiage_mode_on(@input="sound_play('click')" size="is-small" v-model="base.yomiage_mode" native-value="is_yomiage_mode_on") する
      b-radio-button.is_yomiage_mode_off(@input="sound_play('click')" size="is-small" v-model="base.yomiage_mode" native-value="is_yomiage_mode_off") しない

    b-field.sp_move_cancel(custom-size="is-small" label="持ち上げた駒のキャンセル方法" message="右クリックやESCキーでもキャンセル可。この設定はブラウザに保存する")
      b-radio-button.is_move_cancel_hard(@input="sound_play('click')" size="is-small" v-model="base.sp_move_cancel" native-value="is_move_cancel_hard") 移動元をタップ
      b-radio-button.is_move_cancel_easy(@input="sound_play('click')" size="is-small" v-model="base.sp_move_cancel" native-value="is_move_cancel_easy") 他のセルをタップ

    b-field.debug_key(custom-size="is-small" :label="base.DebugInfo.field_label" :message="base.DebugInfo.field_message")
      template(v-for="e in base.DebugInfo.values")
        b-radio-button(:class="e.key" @input="sound_play('click')" size="is-small" v-model="base.debug_key" :native-value="e.key" :type="e.type")
          | {{e.name}}

    b-field.sp_internal_rule_key(custom-size="is-small" :label="base.SpInternalRuleInfo.field_label" :message="base.SpInternalRuleInfo.field_message")
      template(v-for="e in base.SpInternalRuleInfo.values")
        b-radio-button(:class="e.key" @input="sound_play('click')" size="is-small" v-model="base.sp_internal_rule_key" :native-value="e.key" :type="e.type")
          | {{e.name}}

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
