<template lang="pug">
.UserProfileEdit(v-if="g_current_user")
  component(:is="current_component" v-if="current_component")
  //- b-navbar-item(@click="back_handle")
  //-   .delete
  //- b-navbar-item(tag="nuxt-link" :to="{name: 'users-id', params: {id: $route.params.id}}")
  //-   //- .image.is-inline-block
  //-   //-   img.is-rounded(:src="config.avatar_path")
  //-   .ml-2.has-text-weight-bold {{config.name}}さんのプロフィール
  //- template(slot="end" v-if="g_current_user && g_current_user.id === config.id")
  //-   b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'profile-edit'}") 変更
  //- .section
  //-   .container
  //-     component(:is="current_component" v-if="current_component")
  //-       b-image(:src="config.avatar_path")
  //-     .content
  //-       p
  //-         .has-text-weight-bold Twitter
  //-         a.is-block(:href="twitter_url" :target="target_default" ) @{{config.twitter_key}}
  //-       p.box.description.has-background-white-ter.is-shadowless(
  //-         v-if="config.description"
  //-         v-html="auto_link(config.description)")
  //-
  //-     pre(v-if="development_p") {{config}}
</template>

<script>
import the_profile_edit_form       from "./the_profile_edit_form.vue"
import the_profile_edit_image_crop from "./the_profile_edit_image_crop.vue"

export default {
  name: "UserProfileEdit",
  components: {
    the_profile_edit_form,
    the_profile_edit_image_crop,
  },
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
    // http://0.0.0.0:3000/api/users/1.json
    // http://0.0.0.0:4000/users/1
    // return this.$axios.$get(`/api/users/${this.$route.params.id}.json`).then(e => {
    //   this.config = e
    // })
  },
  mounted() {
    this.var_reset()

    // if (this.app.info.warp_to === "profile_edit_image_crop") {
    //   this.current_component = "the_profile_edit_image_crop"
    // }
  },

  beforeDestroy() {
    if (this.unwatch_func) {
      this.unwatch_func()
      this.unwatch_func = null
    }
  },

  methods: {
    var_reset() {
      if (this.unwatch_func) {
        this.unwatch_func()
      }

      this.current_component = "the_profile_edit_form"
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
  },
}
</script>

<style lang="sass">
.UserProfileEdit
  // .navbar-item
  //   img
  //     max-height: none
  //     height: 32px
  //     width: 32px
  .section
    padding-top: 1.5rem
</style>
