<template lang="pug">
.KiwiBookEditForm
  .columns.is-variable.is-0-mobile.is-5-tablet.is-6-desktop
    .column.form_block
      b-field.field_block(label="サムネ位置")
        .control
          .image
            video.is-block(:src="base.book.lemon.browser_path" controls :autoplay="false" :loop="false" ref="video_tag")

      .field_block(v-if="development_p")
        b-field(label="サムネイルにする位置(秒)")
          .control
            b-button(@click="thumbnail_pos_set_handle") 反映
          b-input(v-model.trim="base.book.thumbnail_pos")
        .image.mt-4
          img(:src="base.book.lemon.thumbnail_browser_path")

      b-field.field_block(label="タイトル")
        b-input(v-model.trim="base.book.title" required :maxlength="100" placeholder="動画について説明するタイトルを追加しよう")
      b-field.field_block(label="説明")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5" :maxlength="5000" placeholder="動画の内容を紹介しよう")
      b-field.field_block(label="タグ")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.book.tag_list" rounded :on-paste-separators="[',', ' ']" :confirm-keys="[',', 'Tab', 'Enter']")
      b-field.field_block(label="公開設定" :message="FolderInfo.fetch(base.book.folder_key).message.book")
        b-field.is-marginless
          template(v-for="e in FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key" @input="folder_key_input_handle")
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
      b-field.submit_field
        .control
          b-button.has-text-weight-bold.book_save_handle(@click="base.book_save_handle" type="is-primary" :class="{disabled: !base.save_button_enabled}") {{base.save_button_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookEditForm",
  mixins: [support_child],
  mounted() {
    this.$refs.video_tag.currentTime = this.base.book.thumbnail_pos
    this.$refs.video_tag.addEventListener("timeupdate", this.timeupdate_hook)
  },
  beforeDestroy() {
    this.$refs.video_tag.removeEventListener("timeupdate", this.timeupdate_hook)
  },
  methods: {
    timeupdate_hook(e) {
      this.base.book.thumbnail_pos = e.target.currentTime
    },
    thumbnail_pos_set_handle() {
      this.sound_play("click")
      this.base.book.thumbnail_pos = this.$refs.video_tag.currentTime
    },
    folder_key_input_handle(e) {
      this.sound_play("click")
      const folder_info = this.FolderInfo.fetch(e)
      this.talk(folder_info.name)
    },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookEditForm
  +tablet
    .image
      max-width: 320px
</style>
