<template lang="pug">
.the_profile_edit
  component(:is="current_component")
  debug_print(v-if="app.debug_read_p" :grep_v="/canvas/")
</template>

<script>
import { support }                 from "../support.js"
import the_profile_edit_form       from "./the_profile_edit_form.vue"
import the_profile_edit_image_crop from "./the_profile_edit_image_crop.vue"

export default {
  name: "the_profile_edit",
  mixins: [
    support,
  ],
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

  created() {
    this.var_reset()

    if (this.app.info.warp_to === "profile_edit_image_crop") {
      this.current_component = "the_profile_edit_image_crop"
    }
  },

  beforeDestroy() {
    this.unwatch_func()
  },

  methods: {
    var_reset() {
      if (this.unwatch_func) {
        this.unwatch_func()
      }

      this.current_component = "the_profile_edit_form"
      this.changed_p         = false
      this.croped_image      = null

      this.new_name        = this.app.current_user.name
      this.new_description = this.app.current_user.description
      this.new_twitter_key = this.app.current_user.twitter_key

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
@import "../support.sass"
.the_profile_edit
</style>
