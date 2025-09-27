<template lang="pug">
MainSection.WkbkArticleShowForm
  .container
    .columns
      .column
        b-field(label="タイトル")
          .control
            | {{base.article.title || "(no title)"}}
          //- b-input(v-model.trim="base.article.title" required)

        b-field(label="解説")
          .control
            p(v-html="$gs.simple_format($gs.auto_link(base.article.description))")

        b-field(label="問題集" v-if="base.book")
          .control
            | {{base.article.book.title}}

        b-field(label="種類")
          .control
            | {{base.article.lineage.name}}

        b-field(label="出題時の一言")
          .control
            | {{base.article.direction_message}}

        b-field(label="難易度" custom-class="is-small")
          b-rate(:value="base.article.difficulty" spaced :max="5" :show-score="false" disabled)

        b-field(label="タグ")
          .control
            WkbkTagList(:tag_list="base.article.tag_list" :tag_search_handle="base.tag_search_handle")
            //- b-taglist
            //-   b-tag.is-clickable(v-for="tag in base.article.tag_list" :key="tag" rounded @click.native.prevent.stop="base.tag_search_handle(tag)") {{tag}}

        b-field(label="公開設定")
          .control
            WkbkFolder(:folder_key="base.article.folder_key")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkArticleShowForm",
  mixins: [
    support_child,
  ],
  data() {
    return {
    }
  },
  created() {
  },
  methods: {
  },
  watch: {
    "article.lineage_key": {
      handler(v) {
        this.sfx_play_click()
        this.talk(v)
      },
    },
    "article.mate_skip": {
      handler(v) {
        this.sfx_play_click()
        this.talk(v)
      },
    },
  },
  computed: {
    article()      { return this.base.article                                     },
    // lineage_info() { return this.base.LineageInfo.fetch(this.article.lineage_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.MainSection.section.WkbkArticleShowForm
  +mobile
    padding: 1.0rem
  +tablet
    padding: 1.5rem

  .field:not(:first-child)
    margin-top: 1.5rem
</style>
