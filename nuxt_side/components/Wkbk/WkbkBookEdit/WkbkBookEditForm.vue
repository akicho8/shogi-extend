<template lang="pug">
.WkbkBookEditForm
  .columns.is-variable.is-0-mobile.is-5-tablet.is-6-desktop
    .column
      b-field
        WkbkBookEditFormUpload(:base="base")

      b-field(label="タイトル" label-position="on-border")
        b-input.book_title(v-model.trim="base.book.title" required :maxlength="100" placeholder="問題集について説明するタイトルを追加しましょう")

      b-field(label="説明" label-position="on-border")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5" :maxlength="5000" placeholder="解答者に向けて問題集の内容を紹介しましょう")

      b-field(label="出題順序" label-position="on-border")
        b-select(v-model="base.book.sequence_key" required)
          option(v-for="e in base.SequenceInfo.values" :value="e.key" v-text="e.name")

      b-field(label="タグ" label-position="on-border")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.book.tag_list" rounded :on-paste-separators="[',', ' ']" :confirm-keys="[',', 'Tab', 'Enter']")

      b-field(label="公開設定" custom-class="is-small" :message="FolderInfo.fetch(base.book.folder_key).message.book")
        b-field.is-marginless
          template(v-for="e in FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key" expanded)
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
    .column(v-if="base.book.ordered_bookships.length >= 1 || true")
      WkbkBookEditArticleIndexTable(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookEditForm",
  mixins: [
    support_child,
  ],
  watch: {
    "book.sequence_key": {
      handler(v) {
        const sequence_info = this.base.SequenceInfo.fetch(v)
        this.sfx_play_click()
        this.talk(sequence_info.name)
      },
    },
    "book.folder_key": {
      handler(v) {
        const folder_info = this.FolderInfo.fetch(v)
        this.sfx_play_click()
        this.sfx_stop_all()
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
.WkbkBookEditForm
  // +mobile
  //   margin: 1rem
  //   .field:not(:first-child)
  //     margin-top: 1rem
  +tablet
    // margin: 1.5rem
    .field:not(:first-child)
      margin-top: 1.5rem

  .help
    color: $grey
    font-size: $size-7

  // // iPhoneでselectをタップするとズームするのはフォントサイズが16px未満だから
  // +touch
  //   input, textarea, select
  //     font-size: 16px
</style>
