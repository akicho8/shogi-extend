<template lang="pug">
.the_profile_edit
  .primary_header
    .header_center_title
      | プロフィール編集
    b-icon.header_link_icon.ljust(icon="arrow-left" @click.native="close_handle")

  .image_container.is-flex
    b-field
      b-upload(@input="uploaded_handle")
        .image.is_clickable
          img.is-rounded(:src="img_src")

  .form_container
    .user_name.has-text-centered.has-text-weight-bold.is_clickable(@click="name_edit")
      | {{new_name}}

  .button_container
    .buttons.is-centered
      b-button(@click="hozonsuruo" type="is-primary" :disabled="!updated_p") 保存

  debug_print(:grep_v="/canvas/")
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_profile_edit",
  mixins: [
    support,
  ],
  data() {
    return {
      new_name: this.$parent.info.current_user.name, // まだ app は使えない
      upload_org: null,
      updated_p: false,
    }
  },
  created() {
    this.$watch(() => [this.app.file_info, this.new_name], () => this.updated_p = true, {deep: false})
  },
  // watch: {
  //   file_info() { this.updated_p = true },
  //   new_name()  { this.updated_p = true },
  // },

  methods: {
    close_handle() {
      this.sound_play("click")
      this.app.lobby_setup()
    },

    uploaded_handle(v) {
      this.app.file_info = v
      this.app.mode = "profile_edit2"
    },

    name_edit() {
      this.$buefy.dialog.prompt({
        message: "名前",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: this.new_name, required: true },
        onConfirm: value => this.new_name = _.trim(value),
      })
    },

    hozonsuruo() {
    },

  },
  computed: {
    img_src() {
      return this.fab_src || this.app.current_user.avatar_path
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_profile_edit
  @extend %padding_top_for_primary_header
  .primary_header

  .canvas_container
    flex-direction: column
    align-items: center
    .button
     margin-top: 1.5rem

  .image_container
    margin-top: 2rem
    justify-content: center
    .image
      img
        width: 80px
        height: 80px
  .form_container
    margin: 2.4rem 0.8rem
    justify-content: center
  .button_container
    margin-top: 1.5rem
</style>
