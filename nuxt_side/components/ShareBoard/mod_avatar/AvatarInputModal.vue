<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | アバター設定
  .modal-card-body
    //- https://buefy.org/documentation/field
    b-field.is-marginless(v-bind="validate_message")
      //- https://buefy.org/documentation/input
      b-input.new_user_selected_avatar_input_tag(v-model.trim="new_user_selected_avatar" ref="new_user_selected_avatar_input_tag")
    .avatar_showcase
      template(v-for="e in SB.clund_avatars")
        XemojiWrap(component="a" :key="e" :str="e" @click="show_case_click_handle(e)")
    .preview_container(v-if="avatar_preview_image_url")
      img(:src="avatar_preview_image_url")
  .modal-card-foot
    b-button.avatar_input_modal_close_handle.has-text-weight-normal(@click="SB.avatar_input_modal_close_handle" icon-left="chevron-left")
    b-button.avatar_input_modal_submit_handle(@click="avatar_input_modal_submit_handle" type="is-primary") 確定
</template>

<script>
import { GX } from "@/components/models/gx.js"
import { support_child } from "../support_child.js"

export default {
  name: "AvatarInputModal",
  mixins: [support_child],
  data() {
    return {
      new_user_selected_avatar: this.SB.user_selected_avatar,
    }
  },
  mounted() {
    this.input_focus()
  },
  methods: {
    input_focus() {
      this.desktop_focus_to(this.$refs.new_user_selected_avatar_input_tag)
    },
    avatar_input_modal_submit_handle() {
      this.sfx_click()
      this.SB.avatar_input_modal_validate_and_save(this.new_user_selected_avatar)
    },
    show_case_click_handle(avatar_char) {
      if (this.new_user_selected_avatar !== avatar_char) {
        this.sfx_click()
        this.new_user_selected_avatar = avatar_char
      }
    },
  },
  computed: {
    validate_message() {
      return this.SB.AvatarSupport.validate_message(this.new_user_selected_avatar) ?? {}
    },
    avatar_preview_image_url() {
      return this.SB.avatar_preview_image_url(this.new_user_selected_avatar)
    },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.AvatarInputModal
  +modal_width(480px)
  .modal-card-body
    padding: 1.5rem

    display: flex
    flex-direction: column
    gap: 0.75rem

  .avatar_showcase
    display: flex
    flex-wrap: wrap
    gap: 0.2rem
    img
      display: block
      width: 20px
      height: 20px

  .preview_container
    display: flex
    flex-direction: column
    img
      display: block
      max-height: 128px
      object-fit: contain // 比率維持

.STAGE-development
  .AvatarInputModal
    .avatar_showcase, .preview_container, img
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
