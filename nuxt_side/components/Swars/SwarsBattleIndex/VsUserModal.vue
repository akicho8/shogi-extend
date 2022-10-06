<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | 相手で絞る
  .modal-card-body
    b-field
      b-input(
        v-model="input_body"
        ref="main_input_tag"
        @keydown.native.enter="apply_handle"
        placeholder="ウォーズIDを入力(複数指定可)"
        )
    b-taglist(v-if="present_p(base.remember_vs_user_keys)")
      template(v-for="str in base.remember_vs_user_keys")
        b-tag.is-clickable(@click.native="toggle_handle(str)" :type="{'is-primary': input_list.includes(str)}")
          | {{str}}

  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.apply_handle(@click="apply_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "VsUserModal",
  mixins: [
    support_child,
  ],
  data() {
    return {
      input_body: "",
    }
  },
  mounted() {
    this.input_focus()
  },
  methods: {
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
    toggle_handle(str) {
      this.$sound.play_click()
      this.input_body = this.tags_str_toggle(this.input_body, str)
      if (this.input_body.length >= 1) {
        this.input_body += " "
      }
    },
    close_handle() {
      this.$sound.play_click()
      this.$emit("close")
    },
    apply_handle() {
      this.$sound.play_click()
      this.base.vs_user_keys_remember(this.input_body)
      this.base.vs_user_research_handle(this.input_body)
      this.$emit("close")
    },
  },
  computed: {
    input_list() { return this.str_to_tags(this.input_body) },
  },
}
</script>

<style lang="sass">
.VsUserModal
  +modal_width(30rem)
  .modal-card-body
    padding: 1.0rem
</style>
