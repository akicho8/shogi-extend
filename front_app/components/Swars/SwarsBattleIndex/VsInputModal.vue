<template lang="pug">
.modal-card.VsInputModal
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-6.has-text-weight-bold
      | 対戦相手で絞る

  section.modal-card-body
    b-field
      //- https://buefy.org/documentation/autocomplete
      b-autocomplete(
        ref="main_input_tag"
        max-height="25vh"
        v-model="input_body"
        :data="complete_list"
        placeholder="ウォーズIDを入力(複数指定可)"
        @keydown.native.enter="search_handle"
        append-to-body
        )
    .box(v-if="development_p && false")
      p remember_vs_input_lines={{base.remember_vs_input_lines}}
      p complete_list={{complete_list}}

  footer.modal-card-foot
    b-button.close_button(@click="close_handle" icon-left="chevron-left") キャンセル
    b-button.send_button(@click="search_handle" type="is-primary") 実行
</template>

<script>
import { support_child } from "./support_child.js"
import _ from "lodash"

export default {
  name: "VsInputModal",
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
    document.querySelector("body").classList.add("foo")
  },
  beforeDestroy() {
    document.querySelector("body").classList.remove("foo")
  },
  methods: {
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
    close_handle() {
      this.sound_play("click")
      this.$emit("close")
    },
    search_handle() {
      this.sound_play("click")
      this.$emit("close")
      this.base.vs_input_remember(this.input_body)
      this.base.vs_input_filter_run_handle(this.input_body)
    },
  },
  computed: {
    complete_list() {
      const list = this.base.remember_vs_input_lines
      if (list) {
        return list.filter((option) => {
          return option.toString().toLowerCase().indexOf((this.input_body || "").toLowerCase()) >= 0
        })
      }
    },
  },
}
</script>

<style lang="sass">
// BUG: append-to-body すると横の長さが最大化してしまう。最新の buefy では直っている可能性あり
body.foo > .autocomplete
  .dropdown-menu
    max-width: calc((46ch - 1rem * 2) * 0.66) ! important

.VsInputModal
  +desktop
    width: 46ch
  .modal-card-body
    padding: 1.0rem
  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
