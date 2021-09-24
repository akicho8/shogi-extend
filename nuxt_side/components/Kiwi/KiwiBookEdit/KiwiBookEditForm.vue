<template lang="pug">
.KiwiBookEditForm
  .columns.is-variable.is-0-mobile.is-5-tablet.is-6-desktop
    .column
      b-field.one_block(label="")
        .control
          video.is-block(:src="base.book.lemon.browser_path" controls :autoplay="false" :loop="false")

      //- b-field
      //-   KiwiBookEditFormUpload(:base="base")

      b-field.one_block(label="タイトル")
        b-input(v-model.trim="base.book.title" required :maxlength="100" placeholder="動画について説明するタイトルを追加しましょう")

      b-field.one_block(label="説明")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5" :maxlength="5000" placeholder="解答者に向けて動画の内容を紹介しましょう")

      //- b-field(label="出題順序")
      //-   b-select(v-model="base.book.sequence_key" required)
      //-     option(v-for="e in base.SequenceInfo.values" :value="e.key" v-text="e.name")

      b-field.one_block(label="タグ")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.book.tag_list" rounded type="is-primary is-light" :on-paste-separators="[',', ' ']" :confirm-keys="[',', 'Tab', 'Enter']")

      b-field.one_block(label="公開設定" custom-class="is-small" :message="FolderInfo.fetch(base.book.folder_key).message.book")
        b-field.is-marginless
          template(v-for="e in FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key" expanded)
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
    //- .column(v-if="base.book.ordered_bookships.length >= 1 || true")
    //-   KiwiBookEditArticleIndexTable(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookEditForm",
  mixins: [
    support_child,
  ],
  watch: {
    // "book.sequence_key": {
    //   handler(v) {
    //     const sequence_info = this.base.SequenceInfo.fetch(v)
    //     this.sound_play("click")
    //     this.talk(sequence_info.name)
    //   },
    // },
    "book.folder_key": {
      handler(v) {
        const folder_info = this.FolderInfo.fetch(v)
        this.sound_play("click")
        this.sound_stop_all()
        this.talk(folder_info.name)
      },
    },
  },
  computed: {
    book() { return this.base.book },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.KiwiBookEditForm
  // +mobile
  //   margin: 1rem
  //   .field:not(:first-child)
  //     margin-top: 1rem
  // +tablet
  //   // margin: 1.5rem
  //   .field:not(:first-child)
  //     margin-top: 1.5rem

  .help
    color: $grey
    font-size: $size-7

  +tablet
    video
      max-width: 320px

  // // iPhoneでselectをタップするとズームするのはフォントサイズが16px未満だから
  // +touch
  //   input, textarea, select
  //     font-size: 16px

  .one_block
    margin: 0
    padding: 0.8rem 0 1.2rem
    &.body_field
      padding: 1.0rem
    +tablet
      padding-left: 1.25rem
      padding-right: 1.25rem
      &:hover
        background-color: $white-ter
</style>
