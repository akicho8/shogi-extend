<template lang="pug">
//- (style="width:auto")
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-head
    .modal-card-title
      | ファイル情報
    .delete(@click="close_handle")

  ////////////////////////////////////////////////////////////////////////////////
  .modal-card-body
    | OK

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    //- b-button.test_button(@click="test_handle" v-if="development_p") 追加
    //- b-button.submit_handle(@click="submit_handle" type="is-primary") 送信
</template>

<script>
import { support_child   } from "./support_child.js"

export default {
  name: "MySkeltonModal",
  mixins: [
    support_child,
  ],
  props: {
    // record: { type: Object, required: true },
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    // test_handle() {
    //   this.sound_play("click")
    //   this.base.ml_add_test()
    // },
    // submit_handle() {
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
.MySkeltonModal
  // +tablet
  //   width: 100%
  .modal-card-body
    padding: 1.0rem 1.5rem
    // .field:not(:first-child)
    //   margin-top: 1.25rem
    white-space: pre-wrap
    word-break: break-all

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
