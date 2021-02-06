<template lang="pug">
.WkbkArticleEditForm
  .columns.is-gapless
    .column
      b-field(label="タイトル" label-position="on-border")
        b-input(v-model.trim="base.article.title" required)

      b-field(label="解説" label-position="on-border")
        b-input(v-model.trim="base.article.description" type="textarea")

      b-field(label="問題集" label-position="on-border")
        b-select(v-model="base.article.book_key" expanded)
          option(:value="null")
          option(v-for="e in base.books" :value="e.key")
            | {{e.title}}
            | {{base.FolderInfo.fetch(e.folder_key).pulldown_name}}

      b-field(label="種類" label-position="on-border" v-if="base.LineageInfo")
        b-select(v-model="base.article.lineage_key" expanded)
          option(v-for="e in base.LineageInfo.values" :value="e.key")
            | {{e.name}}

      b-field(label="出題時の一言" label-position="on-border" message="タイトルとは別に一言添えたいときの文章")
        b-input(v-model.trim="base.article.direction_message" placeholder="3手指してください")

      b-field(label="難易度" custom-class="is-small")
        b-rate(v-model="base.article.difficulty" spaced :max="5" :show-score="false")

      b-field
        b-switch(v-model="base.article.mate_skip" :disabled="!lineage_info.mate_validate_on")
          span 最後は無駄合い
          span.has-text-grey.is-size-7.ml-1 なので詰みチェックを省略

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
    "article.difficulty": {
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
