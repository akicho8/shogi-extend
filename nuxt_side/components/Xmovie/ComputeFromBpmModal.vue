<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | BPMから秒数を計算

  .modal-card-body
    b-field(:message="new_one_frame_duration_sec_message")
      b-input(v-model.number="new_bpm" expanded ref="main_input_tag")

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.submit_handle(@click="submit_handle" type="is-primary") 適用
</template>

<script>
import { support_child   } from "./support_child.js"
import Big from "big.js"        // https://github.com/MikeMcl/big.js/

export default {
  name: "ComputeFromBpmModal",
  mixins: [support_child],
  data() {
    return {
      new_bpm: 0,
    }
  },
  mounted() {
    this.new_bpm = this.base.one_frame_duration_sec_bpm120, // 2拍換算で初期値を入れる
    this.input_focus()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    submit_handle() {
      if (this.new_one_frame_duration_sec) {
        this.sound_play("click")
        this.base.one_frame_duration_sec = this.new_one_frame_duration_sec
        this.$emit("close")
      }
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
  },
  computed: {
    new_one_frame_duration_sec() {
      if (this.new_bpm > 0) {
        return (new Big(this.new_bpm)).div(120).toNumber()
      }
    },
    new_one_frame_duration_sec_message() {
      if (!this.new_one_frame_duration_sec) {
        return "?"
      }
      return `${this.new_one_frame_duration_sec} 秒`
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.ComputeFromBpmModal
  .modal-card, .modal-card-content
    width: unset
    min-width: 24rem

  .modal-card-body
    padding: 1.5rem 1.5rem
    // white-space: pre-wrap ← XXX: これがあると clerfix の高さがおかしくなり message の上にスペースが空いてしまう

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
