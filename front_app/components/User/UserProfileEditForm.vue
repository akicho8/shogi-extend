<template lang="pug">
.UserProfileEditForm.has-background-white-bis
  DebugBox
    div valid_p        = {{valid_p}}
    div name_invalid_p = {{name_invalid_p}}

  b-navbar(type="is-primary" wrapper-class="container" :mobile-burger="false" spaced)
    template(slot="start")
      b-navbar-item.has-text-weight-bold(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item(@click="test_handle" v-if="development_p") 不正入力テスト
      b-navbar-item.has-text-weight-bold(@click="save_handle") 保存

  .section
    .container
      .columns.is-centered
        .column.is-7-desktop
          .has-text-centered
            b-upload(@input="avatar_upload_handle" @click.native="sound_play('click')")
              figure.image.is_clickable
                img.is-rounded(:src="image_source")
                .image_same_size_box
                  b-icon.has-text-white(icon="camera" size="is-large")

          b-field(label-position="on-border" label="名前" :type="name_invalid_p ? 'is-danger' : ''")
            b-input(type="text" v-model.trim="base.new_name")

          b-field(label-position="on-border" label="Twitterアカウント")
            b-input(type="text" v-model.trim="base.new_twitter_key")

          b-field(label-position="on-border" label="自己紹介")
            b-input(type="textarea" v-model.trim="base.new_description" rows="6")

</template>

<script>
import _ from "lodash"

export default {
  name: "UserProfileEditForm",
  props: {
    base: { type: Object, required: true },
  },
  methods: {
    // キャンセル
    cancel_handle() {
      this.sound_play("click")
      this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
    },

    // アバター画像アップロード(と同時に切り抜きモードに移動)
    avatar_upload_handle(v) {
      this.sound_play('click')
      this.base.upload_file_info = v
      this.base.current_component = "UserProfileEditImageCrop"
    },

    test_handle() {
      this.base.new_twitter_key = "1234567890123456"
      this.save_handle()
    },

    // 保存
    async save_handle() {
      this.sound_play("click")

      // 変な名前を弾くため今は冗長だけどこれでいい
      if (this.name_invalid_p) {
        this.toast_ng("名前を入力してください")
        return
      }

      const params = {
        name:                this.base.new_name,
        profile_description: this.base.new_description,
        profile_twitter_key: this.base.new_twitter_key,
        croped_image:        this.base.croped_image,
      }

      const retv = await this.$axios.$put("/api/settings/profile_update", params)
      this.notice_collector_run(retv)
      if (this.notice_collector_has_error(retv)) {
        return
      }

      // profile_update の結果を取るのではなく別APIで再取得する
      // 直後に遷移しているので一見不要な処理な気がするが、
      // 詳細は g_current_user とは異なるスコープなのでこの処理は必要
      await this.a_auth_user_fetch()
      this.base.var_reset()

      // 詳細に戻る
      this.$router.push({name: "users-id", params: {id: this.g_current_user.id}})
    },
  },

  computed: {
    // 入力がすべて保存できる状態か？
    valid_p() {
      return !this.name_invalid_p
    },

    // 名前が不正か？
    name_invalid_p() {
      if (_.isEmpty(this.base.new_name)) {
        return true
      }
      if (/^([._])$/.test(this.base.new_name)) {
        return true
      }
      return false
    },

    image_source() {
      return this.base.croped_image || this.g_current_user.avatar_path
    },
  },
}
</script>

<style scoped lang="sass">
.UserProfileEditForm
  min-height: 100vh

  .section
    padding-top: 2.8rem

  .image
    img
      width: 256px
      filter: brightness(0.8)
    position: relative
    .image_same_size_box
      position: absolute
      top: 0
      width: 100%
      height: 100%
      display: flex
      align-items: center
      justify-content: center

  .field
    margin-top: 2rem
</style>
