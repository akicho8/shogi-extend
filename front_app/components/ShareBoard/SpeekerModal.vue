<template lang="pug">
.modal-card.SpeekerModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | メッセージ

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field
      b-input(v-model.trim="speeker_message" ref="message_input_tag")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.apply_button(@click="send_handle" type="is-primary") 送信
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SpeekerModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      speeker_message: "",
    }
  },
  mounted() {
    this.focus_to_input()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    send_handle() {
      if (this.speeker_message) {
        this.sound_play("click")
        this.base.speeker_share({message: this.speeker_message})
        this.speeker_message = ""
        this.focus_to_input()
      }
    },
    focus_to_input() {
      this.desktop_focus_to(this.$refs.message_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.SpeekerModal
  +desktop
    width: 40ch
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
