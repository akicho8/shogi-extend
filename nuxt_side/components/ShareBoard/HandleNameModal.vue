<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | ハンドルネーム
  .modal-card-body
    b-field
      b-input(v-model.trim="new_name" ref="main_input_tag")
  .modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.save_handle(@click="save_handle" type="is-primary") 保存
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "HandleNameModal",
  mixins: [support_child],
  props: {
    params: { type: Object, required: false, default: null, },
  },
  data() {
    return {
      new_name: this.base.user_name,
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
    save_handle() {
      this.sound_play("click")
      this.new_name = _.trim(this.new_name)
      if (!this.base.handle_name_validate(this.new_name)) {
        return
      }
      this.base.handle_name_set(this.new_name)

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
@import "support.sass"
.HandleNameModal
  +modal_width(320px)
  .modal-card-body
    padding: 1.5rem
</style>
