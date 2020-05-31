<template lang="pug">
.the_profile_edit_form
  .primary_header
    .header_link_icon.ljust(@click="cancel_handle") キャンセル
    .header_link_icon.rjust.has-text-weight-bold(@click="profile_update_handle" :class="{disabled: !$parent.changed_p}") 保存
    .header_center_title プロフィール編集

  .image_container.is-flex
    b-field
      b-upload(@input="user_icon_upload_handle" @click.native="sound_play('click')")
        .image.is_clickable
          img.is-rounded(:src="image_source")

  .form_container
    .user_name.has-text-centered.has-text-weight-bold.is_clickable(@click="name_edit_handle")
      | {{$parent.new_name}}
</template>

<script>
import { support } from "./support.js"

export default {
  name: "the_profile_edit",
  mixins: [
    support,
  ],
  methods: {
    cancel_handle() {
      this.sound_play("click")
      this.app.lobby_setup()
    },

    user_icon_upload_handle(v) {
      this.sound_play('click')
      this.$parent.upload_file_info = v
      this.$parent.p_mode = "the_profile_edit_image_crop"
    },

    name_edit_handle() {
      this.sound_play("click")
      this.$buefy.dialog.prompt({
        message: "名前",
        confirmText: "更新",
        cancelText: "キャンセル",
        inputAttrs: { type: 'text', value: this.$parent.new_name, required: true },
        onCancel: value => this.sound_play("click"),
        onConfirm: value => {
          this.sound_play("click")
          this.$parent.new_name = _.trim(value)
        },
      })
    },

    profile_update_handle() {
      this.sound_play("click")
      this.remote_fetch("PUT", this.app.info.put_path, { remote_action: "profile_update", user_name: this.$parent.new_name, croped_image: this.$parent.croped_image }, e => {
        this.app.current_user = e.current_user
        this.ok_notice("保存しました")
        this.$parent.var_reset()

        if (this.app.config.save_and_return) {
          this.app.lobby_setup()
        }
      })
    },
  },

  computed: {
    image_source() {
      return this.$parent.croped_image || this.app.current_user.avatar_path
    },
  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_profile_edit_form
  @extend %padding_top_for_primary_header
  .primary_header
    justify-content: space-between

  .image_container
    margin-top: 4rem
    justify-content: center
    .image
      img
        width: 80px
        height: 80px

  .form_container
    margin-top: 1rem
    justify-content: center

  .button_container
    margin-top: 4rem
</style>
