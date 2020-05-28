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
      | {{app.new_name}}

  .button_container
    .buttons.is-centered
      b-button(@click="hozonsuruo" type="is-primary" :disabled="!app.updated_p") 保存
      b-button(@click="hozonsuruo" type="is-primary") 保存

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
    }
  },
  created() {
    if (!this.app.new_name) {
      this.app.new_name = this.$parent.info.current_user.name
    }

    this.$watch(() => [this.app.file_info, this.app.new_name], () => this.app.updated_p = true, {deep: false})
  },
  // watch: {
  //   file_info() { this.app.updated_p = true },
  //   app.new_name()  { this.app.updated_p = true },
  // },

  beforeDestroy() {
    this.app.croped_image = null
    this.app.updated_p = false
  },

  methods: {
    close_handle() {
      this.sound_play("click")
      this.app.lobby_setup()
    },

    uploaded_handle(v) {
      this.app.file_info = v
      this.app.mode = "image_crop"
    },

    name_edit() {
      this.$buefy.dialog.prompt({
        message: "名前",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: this.app.new_name, required: true },
        onConfirm: value => this.app.new_name = _.trim(value),
      })
    },

    hozonsuruo() {
      this.sound_play("click")
      this.remote_fetch("PUT", this.app.info.put_path, { remote_action: "profile_update", user_name: this.app.new_name, croped_image: this.app.croped_image }, e => {
        this.app.current_user = e.current_user
        this.ok_notice("保存しました")
      })
    },
  },
  computed: {
    img_src() {
      return this.app.croped_image || this.app.current_user.avatar_path
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
