<template lang="pug">
.UserEditProfileForm.has-background-white-bis
  DebugBox(v-if="development_p")
    div valid_p        = {{valid_p}}
    div name_invalid_p = {{name_invalid_p}}

  MainNavbar
    template(slot="start")
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="cancel_handle") キャンセル
    template(slot="end")
      b-navbar-item(@click="test_handle" v-if="development_p") 不正入力テスト
      b-navbar-item.has-text-weight-bold.px_5_if_tablet(@click="save_handle") 保存

  MainSection
    .container
      .columns.is-centered
        .column.has-text-centered
          // @click.native="sound_play('click')" すると2連続で呼ばれてしまうので指定してない
          // @click.native="toast_ok(1)" すると2回呼ばれていることがわかる
          b-upload(@input="avatar_upload_handle" @click.native="debug_alert('2回呼ばれる不具合があるため効果音OFF')")
            figure.image.is-clickable
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
  name: "UserEditProfileForm",
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
      this.base.current_component = "UserEditProfileImageCrop"
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
        this.toast_warn("名前を入力してください")
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
      if (this.blank_p(this.base.new_name)) {
        return true
      }
      if (/^([._])$/.test(this.base.new_name)) { // これはなんだ？？？ デバッグ用？
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

<style lang="sass">
.UserEditProfileForm
  min-height: 100vh

  .MainSection.section
    padding-top: 2.8rem

  .image
    img
      width: 256px
    position: relative
    .image_same_size_box
      position: absolute
      top: 0
      width: 100%
      height: 100%
      display: flex
      align-items: center
      justify-content: center
      .icon
        filter: drop-shadow(0px 0px 16px rgba(0, 0, 0, 1.0))

  .field
    margin-top: 2rem

  .column
    +tablet
      max-width: 40rem
</style>
