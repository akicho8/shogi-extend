<template lang="pug">
.the_profile_edit_form
  .primary_header
    .header_item.with_text.ljust(@click="cancel_handle") キャンセル
    .header_item.with_text.rjust.has-text-weight-bold(@click="profile_update_handle" :class="{disabled: !$parent.changed_p}") 保存
    .header_center_title プロフィール編集

  .image_container.is-flex
    b-field
      b-upload(@input="user_icon_upload_handle" @click.native="sound_play('click')")
        .image.is_clickable
          img.is-rounded(:src="image_source")

  .form_container
    #user_name_input_field.user_name.has-text-centered.has-text-weight-bold.is_clickable(@click="name_edit_handle")
      | {{$parent.new_name}}

    b-field(label="自己紹介" label-position="on-border")
      b-input.new_description(type="textarea" v-model="$parent.new_description" rows="6" size="is-small")

    b-field(label="Twitterアカウント" label-position="on-border" v-if="app.debug_write_p")
      b-input(type="text" v-model="$parent.new_twitter_key" size="is-small")
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

      const params = {
        name:                this.$parent.new_name,
        profile_description: this.$parent.new_description,
        profile_twitter_key: this.$parent.new_twitter_key,
        croped_image:        this.$parent.croped_image,
      }

      this.api_put("profile_update", params, e => {
        if (e.error_message) {
          this.warning_notice(e.error_message)
        }
        if (e.user) {
          this.app.current_user = e.user
          this.ok_notice("保存しました")

          this.$parent.var_reset()

          if (this.app.config.profile_save_and_return) {
            this.app.lobby_setup()
          }
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
    .field
      margin: 1.5rem 0.5rem

  .button_container
    margin-top: 4rem

</style>
