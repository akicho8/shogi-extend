<template lang="pug">
.KiwiBookEditForm
  .columns.is-variable.is-0-mobile.is-5-tablet.is-6-desktop
    .column.form_block
      b-field.field_block(label="")
        .control
          video.is-block(:src="base.book.lemon.browser_path" controls :autoplay="false" :loop="false")
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
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key" expanded)
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
      b-field.submit_field
        .control
          b-button.has-text-weight-bold.book_save_handle(@click="base.book_save_handle" type="is-primary" expanded :class="{disabled: !base.save_button_enabled}") {{base.save_button_name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookEditForm",
  mixins: [support_child],
  watch: {
    "base.book.folder_key": {
      handler(v) {
        const folder_info = this.FolderInfo.fetch(v)
        this.sound_play("click")
        this.sound_stop_all()
        this.talk(folder_info.name)
      },
    },
  },
  // computed: {
  //   book() { return this.base.book },
  // },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookEditForm
  +tablet
    video
      max-width: 320px
</style>
