<template lang="pug">
.modal-card
  .modal-card-head
    .modal-card-title
      | アバター設定
  .modal-card-body
    //- https://buefy.org/documentation/field
    b-field.mb-2(v-bind="validate_message")
      //- https://buefy.org/documentation/input
      b-input.new_user_selected_avatar_input_tag(v-model.trim="new_user_selected_avatar" ref="new_user_selected_avatar_input_tag")
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
  +modal_width(320px)
  .modal-card-body
    padding: 1.5rem
  .preview_container
    display: flex
    flex-direction: column
    img
      max-height: 128px
      object-fit: contain // 比率維持

.STAGE-development
  .AvatarInputModal
    .preview_container
      border: 1px dashed change_color($primary, $alpha: 0.5)
    img
      border: 1px dashed change_color($primary, $alpha: 0.5)
</style>
