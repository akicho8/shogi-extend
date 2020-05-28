<template lang="pug">
.the_profile_edit
  the_profile_edit_form(v-if="p_mode === 'xform'")
  the_profile_edit_image_crop(v-if="p_mode === 'image_crop'")
  debug_print(:grep_v="/canvas/")
</template>

<script>
import { support } from "./support.js"

import the_profile_edit_image_crop from "./the_profile_edit_image_crop.vue"
import the_profile_edit_form       from "./the_profile_edit_form.vue"

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
      unwatch_func:     null,
      changed_p:        null,   // フォームの内容を変更した？(trueで保存ボタンが有効になる)
      p_mode:           null,   // コンポーネント切り替え用

      // form
      upload_file_info: null,   // inputタグでアップロードしたそのもの
      croped_image:     null,   // 切り取った画像
      new_name:         null,   // 変更した名前
    }
  },
  created() {
    this.var_reset()
  },

  beforeDestroy() {
    this.unwatch_func()
  },

  methods: {
    var_reset() {
      if (this.unwatch_func) {
        this.unwatch_func()
      }

      this.p_mode = "xform"
      this.changed_p = false
      this.croped_image = null
      this.new_name = this.app.info.current_user.name

      this.unwatch_func = this.$watch(() => [
        this.croped_image,
        this.new_name,
      ], () => this.changed_p = true, {deep: false})
    },

  },
}
</script>

<style lang="sass">
@import "support.sass"
.the_profile_edit
</style>
