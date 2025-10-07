<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | ハンドルネーム
  .modal-card-body
    b-field
      b-input(v-model.trim="new_name" ref="main_input_tag")
  .modal-card-foot
    b-button.close_handle.has-text-weight-normal(@click="close_handle" icon-left="chevron-left")
    b-button.save_handle(@click="save_handle" type="is-primary") 保存
</template>

<script>
import { support_child } from "./support_child.js"
import { HandleNameNormalizer } from "@/components/models/handle_name/handle_name_normalizer.js"

export default {
  name: "HandleNameModal",
  mixins: [support_child],
  props: {
    params: { type: Object, required: false, default: null, },
  },
  data() {
    return {
      new_name: this.SB.user_name,
    }
  },
  mounted() {
    this.input_focus()
  },
  methods: {
    close_handle() {
      this.sfx_click()
      this.$emit("close")
    },
    save_handle() {
      this.sfx_click()
      this.new_name = HandleNameNormalizer.normalize(this.new_name)
      if (this.SB.handle_name_invalid_then_toast_warn(this.new_name)) {
        return
      }

      this.SB.handle_name_set(this.new_name)

      // ハンドルネームを正しく入力した場合にのみ success_callback を実行する
      if (this.params) {
        if (this.params.success_callback) {
          this.params.success_callback()
        }
      }

      this.$emit("close")
    },
    input_focus() {
      this.desktop_focus_to(this.$refs.main_input_tag)
    },
  },
}
</script>

<style lang="sass">
@import "./sass/support.sass"
.HandleNameModal
  +modal_width(320px)
  .modal-card-body
    padding: 1.5rem
</style>
