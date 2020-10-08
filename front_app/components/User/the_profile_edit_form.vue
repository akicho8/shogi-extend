<template lang="pug">
.the_profile_edit_form.has-background-white-bis
  b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
    //- template(slot="brand")
    //-   b-navbar-item キャンセル
    template(slot="start")
      //- b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
      //-   .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
    template(slot="end")
      //- b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
      //-   .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
      b-navbar-item.has-text-weight-bold(@click="save_handle") 保存

  //- .primary_header
  //-   .header_item.with_text.ljust(@click="cancel_handle") キャンセル
  //-   .header_item.with_text.rjust.has-text-weight-bold(@click="save_handle" :class="{disabled: !$parent.changed_p}") 保存
  //-   .header_center_title プロフィール編集

  .section
    .container
      .columns.is-centered
        .column.is-7-desktop
          .has-text-centered
            b-upload(@input="avatar_upload_handle" @click.native="sound_play('click')")
              figure.image.is_clickable
                img.is-rounded(:src="image_source")

          b-field(label="名前" label-position="on-border")
            b-input(type="text" v-model="$parent.new_name" required)

          b-field(label="Twitterアカウント" label-position="on-border")
            b-input(type="text" v-model="$parent.new_twitter_key")

          b-field(label="自己紹介" label-position="on-border")
            b-input.new_description(type="textarea" v-model="$parent.new_description" rows="6")

</template>

<script>
export default {
  name: "the_profile_edit",
  mixins: [
    // support,
  ],
  methods: {
    // キャンセル
    cancel_handle() {
      this.sound_play("click")
      this.app.lobby_setup()
    },

    // アバター画像アップロード(と同時に切り抜きモードに移動)
    avatar_upload_handle(v) {
      this.sound_play('click')
      this.$parent.upload_file_info = v
      this.$parent.current_component = "the_profile_edit_image_crop"
    },

    // 保存
    save_handle() {
      this.sound_play("click")

      const params = {
        name:                this.$parent.new_name,
        profile_description: this.$parent.new_description,
        profile_twitter_key: this.$parent.new_twitter_key,
        croped_image:        this.$parent.croped_image,
      }

      this.api_put("user_profile_update", params, e => {
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
      return this.$parent.croped_image || this.g_current_user.avatar_path
    },

    // 名前編集の初期値
    // ちゃんとした名前の入っていない人の初期値は空にする
    default_name() {
      return this.$parent.new_name
      // if (this.app.current_user.name_input_at) {
      //   return this.$parent.new_name
      // } else {
      //   return ""
      // }
    },
  },
}
</script>

<style scoped lang="sass">
.the_profile_edit_form
  min-height: 100vh

  .section
    padding-top: 2.8rem

  .image
    img
      width: 256px
      height: 256px

  .field
    margin-top: 2rem
</style>
