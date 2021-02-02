<template lang="pug">
.WkbkArticleEditForm
  .columns.is-gapless
    .column
      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.article.title" required)

      b-field(label="解説" label-position="on-border")
        b-input(v-model.trim="base.article.description" type="textarea" rows="8")

      b-field(label="問題集" label-position="on-border")
        b-select(v-model="base.article.book_id" expanded)
          option(:value="null")
          option(v-for="e in base.books" :value="e.id")
            | {{e.title}}
            | {{base.FolderInfo.fetch(e.folder_key).pulldown_name}}

      b-field(label="種類" label-position="on-border" v-if="base.LineageInfo")
        b-select(v-model="base.article.lineage_key" expanded)
          option(v-for="e in base.LineageInfo.values" :value="e.key")
            | {{e.name}}

      b-field(label="出題時の一言" label-position="on-border" message="何手指してほしいかやヒントを伝えたいときだけ入力してください")
        b-input(v-model.trim="base.article.direction_message" placeholder="3手指してください")

      b-field
        b-switch(v-model="base.article.mate_skip" :disabled="!lineage_info.mate_validate_on")
          | 最後は無駄合いなので詰みチェックを省略する

      b-field(label="タグ" label-position="on-border")
        //- https://buefy.org/documentation/taginput
        b-taginput(v-model="base.article.owner_tag_list" rounded :confirm-key-codes="[13, 188, 9, 32]")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleEditForm",
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
    "article.lineage_key": {
      handler(v) {
        this.sound_play("click")
        this.talk(v)
      },
    },
    "article.mate_skip": {
      handler(v) {
        this.sound_play("click")
        this.talk(v)
      },
    },
  },
  computed: {
    article()      { return this.base.article                                     },
    lineage_info() { return this.base.LineageInfo.fetch(this.article.lineage_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleEditForm
  margin: $wkbk_share_gap 0
  .field:not(:first-child)
    margin-top: $wkbk_share_gap
  .help
    color: $grey
    font-size: $size-7
</style>
