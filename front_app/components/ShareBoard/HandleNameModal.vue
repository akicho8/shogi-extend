<template lang="pug">
.modal-card
  ////////////////////////////////////////////////////////////////////////////////
  header.modal-card-head.is-justify-content-space-between
    p.modal-card-title.is-size-5.has-text-weight-bold
      | ハンドルネーム

  ////////////////////////////////////////////////////////////////////////////////
  section.modal-card-body
    b-field
      b-input(v-model.trim="new_name" ref="main_input_tag")

  footer.modal-card-foot
    b-button.close_handle(@click="close_handle" icon-left="chevron-left") 閉じる
    b-button.save_handle(@click="save_handle" type="is-primary") 保存
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "HandleNameModal",
  mixins: [
    support_child,
  ],
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
      const s = this.new_name

      if (s.length === 0) {
        this.toast_warn("入力してください")
        return
      }

      if (s.match(/[一-龠]/)) {
        // OK
      } else {
        if (s.length <= 1 || s.match(/名無し|ななし/)) {
          if (false) {
            this.toast_warn("真面目に入力してないのでログインしてください")
            this.sns_login_modal_open()
          } else {
            this.toast_warn("真面目に入力してください")
            return
          }
        }
      }

      this.base.handle_name_set(this.new_name)
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
  +tablet
    .animation-content
      max-width: 640px // $buefy.modal.open({width: 640}) 相当
      .modal-card
        width: auto    // buefyのデモを参考
        .modal-card-body
          padding: 1.25rem
  +mobile
    .animation-content
      max-width: 96vw
      .modal-card
        max-height: 90vh
        .modal-card-body
          padding: 1.25rem 0.75rem

  .modal-card-foot
    justify-content: space-between
    .button
      min-width: 6rem
      font-weight: bold
</style>
