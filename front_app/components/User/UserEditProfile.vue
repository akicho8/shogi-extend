<template lang="pug">
.UserEditProfile(v-if="g_current_user")
  template(v-if="false")
    component(:is="current_component" v-if="current_component")
  template(v-else)
    UserEditProfileForm(      :base="this" v-if="current_component === 'UserEditProfileForm'"      )
    UserEditProfileImageCrop( :base="this" v-if="current_component === 'UserEditProfileImageCrop'" )
</template>

<script>
export default {
  name: "UserEditProfile",
  data() {
    return {
      // meta
      unwatch_func:      null,
      changed_p:         null,   // フォームの内容を変更した？(trueで保存ボタンが有効になる)
      current_component: null,   // コンポーネント切り替え用

      // form
      upload_file_info: null,   // inputタグでアップロードしたそのもの
      croped_image:     null,   // 切り取った画像
      new_name:         null,   // 変更した名前
      new_description:  null,   // プロフィール
      new_twitter_key:  null,   // Twitterアカウント
    }
  },
  fetch() {
    if (!this.g_current_user) {
      this.$nuxt.error({statusCode: 404, message: "ログインしてください"})
    }
  },
  head() {
    return {
      title: this.page_title,
    }
  },

  mounted() {
    this.var_reset()
  },

  beforeDestroy() {
    this.watch_clear()
  },

  methods: {
    var_reset() {
      this.watch_clear()

      this.current_component = "UserEditProfileForm"
      this.changed_p         = false
      this.croped_image      = null

      this.new_name        = this.g_current_user.name
      this.new_description = this.g_current_user.description
      this.new_twitter_key = this.g_current_user.twitter_key

      this.unwatch_func = this.$watch(() => [
        this.croped_image,

        this.new_name,
        this.new_description,
        this.new_twitter_key,
      ], () => this.changed_p = true, {deep: false})
    },

    watch_clear() {
      if (this.unwatch_func) {
        this.unwatch_func()
        this.unwatch_func = null
      }
    },
  },

  computed: {
    page_title() {
      return "プロフィール編集"
    },
  },
}
</script>

<style lang="sass">
.UserEditProfile
</style>
