<template lang="pug">
.WkbkBookEditForm
  .columns.is-gapless
    .column
      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.book.title" required)

      b-field(label="備考" label-position="on-border")
        b-input(v-model.trim="base.book.description" type="textarea" rows="5")

      b-field(label="表示範囲" custom-class="is-small" v-if="base.FolderInfo")
        b-field.is-marginless
          template(v-for="row in base.FolderInfo.values")
            b-radio-button(v-model="base.book.folder_key" :native-value="row.key") {{row.name}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookEditForm",
  mixins: [
    support_child,
  ],
  data() {
    return {
    }
  },
  created() {
  },
  watch: {
    "book.folder_key": {
      handler(v) {
        const folder_info = this.base.FolderInfo.fetch(v)
        this.sound_play("click")
        this.talk(folder_info.name)
      },
    },
  },
  computed: {
    book()     { return this.base.book                                     },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookEditForm
  margin: $wkbk_share_gap
  .field:not(:first-child)
    margin-top: $wkbk_share_gap
  .help
    color: $grey
    font-size: $size-7
  .b-radio
    font-size: $size-7
</style>
