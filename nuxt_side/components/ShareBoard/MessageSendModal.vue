<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | メッセージ
    b-button.test_button(type="is-small" @click="test_handle" v-if="development_p") 追加
  .modal-card-body
    ShareBoardMessageLog(:base="base" ref="ShareBoardMessageLog")
    b-field
      b-input(v-model="base.message_body" ref="message_input_tag")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left")
    b-button.ms_audience_send_button(@click="send_handle({message_scope: 'ms_audience'})" type="is-success" v-if="base.watching_member_count >= 1") 観戦者宛
    b-button.send_button(@click="send_handle()" type="is-primary") 送信
</template>

<script>
import { support_child } from "./support_child.js"

const CLOSE_IF_BLANK_MESSAGE_POST = false // 空送信で閉じる

export default {
  name: "MessageSendModal",
  mixins: [support_child],
  mounted() {
    this.input_focus()

    // 本当は ShareBoardMessageLog.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    this.base.ml_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.sound_play_click()
      this.$emit("close")
    },
    test_handle() {
      this.sound_play_click()
      this.base.ml_add_test()
    },
    send_handle(options = {}) {
      if (this.blank_p(this.base.message_body)) {
        if (CLOSE_IF_BLANK_MESSAGE_POST) {
          this.close_handle()
          return
        } else {
          this.sound_play("x")
          this.base.message_body = ""
          this.input_focus()
          return
        }
      }
      this.sound_play_click()
      this.base.message_share({message: this.base.message_body, ...options})
      this.base.message_body = ""
      this.input_focus()
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.message_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.MessageSendModal
  +modal_width(24rem)
  .modal-card-body
    padding: 1.0rem
</style>
