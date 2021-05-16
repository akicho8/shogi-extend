<template lang="pug">
//- (style="width:auto")
.modal-card.MainSettingModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | 設定

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field.ctrl_mode(custom-size="is-small" label="対局時のコントローラー表示" message="時計が動いているときを対局中と想定している。誤タップが気になる場合は隠そう")
      b-radio-button.is_ctrl_mode_hidden(@input="sound_play('click')" size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_hidden") 隠す
      b-radio-button.is_ctrl_mode_visible(@input="sound_play('click')" size="is-small" v-model="base.ctrl_mode" native-value="is_ctrl_mode_visible") 表示
    b-field.yomiage_mode(custom-size="is-small" label="検討時の棋譜読み上げ" message="時計を設置していないときを検討時と想定している。検討に集中したいときは「しない」にしよう")
      b-radio-button.is_yomiage_mode_on(@input="sound_play('click')" size="is-small" v-model="base.yomiage_mode" native-value="is_yomiage_mode_on") する
      b-radio-button.is_yomiage_mode_off(@input="sound_play('click')" size="is-small" v-model="base.yomiage_mode" native-value="is_yomiage_mode_off") しない
    b-field.sync_mode(custom-size="is-small" label="同期方法" v-if="development_p")
      b-radio-button.is_sync_mode_on(@input="sound_play('click')" size="is-small" v-model="base.sync_mode" native-value="is_sync_mode_hard") 完全同期
      b-radio-button.is_sync_mode_off(@input="sound_play('click')" size="is-small" v-model="base.sync_mode" native-value="is_sync_mode_soft") 着手
    b-field.internal_rule(custom-size="is-small" label="将棋のルール" message="無視にすると「自分の手番では自分の駒を操作する」の制約を無視する。そのため自分の手番で相手の駒を操作できる。それを利用して後手のときも先手の駒を動かせばずっと先手側を操作できるので先手だけの囲いの手順の棋譜を作ったりするのが簡単になる。しかし反則のため他のアプリでは読めない棋譜になってしまう")
      b-radio-button(@input="sound_play('click')" size="is-small" v-model="base.internal_rule" native-value="strict") 守る
      b-radio-button(@input="sound_play('click')" size="is-small" v-model="base.internal_rule" native-value="free" type="is-danger") 無視
    b-field.debug_mode(custom-size="is-small" label="デバッグモード")
      b-radio-button.is_debug_mode_off(@input="sound_play('click')" size="is-small" v-model="base.debug_mode" native-value="is_debug_mode_off") OFF
      b-radio-button.is_debug_mode_on(@input="sound_play('click')" size="is-small" v-model="base.debug_mode" native-value="is_debug_mode_on") ON

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
  +tablet
    width: 32rem
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
