<template lang="pug">
.modal-card.MessageSendModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | メッセージ

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    ShareBoardMessageLogs(:base="base" ref="ShareBoardMessageLog")
    b-field
      b-input(v-model.trim="message_body" ref="message_input_tag")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.test_button(@click="test_handle" v-if="development_p") 追加
    b-button.send_button(@click="send_handle" type="is-primary") 送信
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "MessageSendModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      message_body: "",
    }
  },
  mounted() {
    this.input_focus()

    // 本当は ShareBoardMessageLogs.vue の mounted で実行したかったが
    // まだコンポーネントが表示されてないので効かなかった
    // おそらく modal が表示されるまでに1フレームぐらいかかってるっぽい
    this.base.ml_scroll_to_bottom()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    test_handle() {
      this.sound_play("click")
      this.base.ml_add_test()
    },
    send_handle() {
      if (this.message_body) {
        this.sound_play("click")
        this.base.message_share({message: this.message_body})
        this.message_body = ""
        this.input_focus()
      }
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
  +desktop
    width: 40ch
  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
