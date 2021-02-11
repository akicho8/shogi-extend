<template lang="pug">
.WkbkBookEditForm
  .columns.is-gapless
    .column
      WkbkBookEditFormUpload(:base="base")

      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.book.title" required)

      b-field(label="概要" label-position="on-border")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5")

      b-field(label="出題順序" label-position="on-border")
        b-select(v-model="base.book.sequence_key" required)
          option(v-for="e in base.SequenceInfo.values" :value="e.key" v-text="e.name")

      b-field(label="公開設定" custom-class="is-small" :message="FolderInfo.fetch(base.book.folder_key).message.book")
        b-field.is-marginless
          template(v-for="e in FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="e.key")
              b-icon(:icon="e.icon" size="is-small")
              span {{e.name}}
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
        this.sound_play("click")
        this.talk(sequence_info.name)
      },
    },
    "book.folder_key": {
      handler(v) {
        const folder_info = this.FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk_stop()
        this.talk(folder_info.message.book)
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
  +mobile
    --gap: calc(#{$wkbk_share_gap} * 0.75)
  +tablet
    --gap: #{$wkbk_share_gap}

  margin: var(--gap)

  .field:not(:first-child)
    margin-top: var(--gap)

  .help
    color: $grey
    font-size: $size-7

  // iPhoneでselectをタップするとズームするのはフォントサイズが16px未満だから
  +touch
    input, textarea, select
      font-size: 16px
</style>
