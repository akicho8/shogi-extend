<template lang="pug">
.modal-card.VsInputModal
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 対戦相手で絞る

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-notification.mb-4(:closable="false")
      | この機能を使う場合はいったんログインしてください

    b-field
      b-input(v-model="vs_user_key" ref="main_input_tag" placeholder="対戦相手のウォーズIDを入力")

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.send_button(@click="search_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "VsInputModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      vs_user_key: "",
    }
  },
  mounted() {
    this.input_focus()
  },
  methods: {
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    search_handle() {
      this.sound_play("click")
      this.$emit("close")
      this.base.vs_input_filter_run_handle(this.vs_user_key)
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
  },
}
</script>

<style lang="sass">
.VsInputModal
  // +desktop
  //   width: 40ch
  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
