<template lang="pug">
.WkbkArticleShowForm
  .columns.is-gapless
    .column
      b-field(label="タイトル")
        .control
          | {{base.article.title}}
        //- b-input(v-model.trim="base.article.title" required)

      b-field(label="解説")
        .control
          p(v-html="simple_format(auto_link(base.article.description))")

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
          b-taglist
            template(v-for="tag in base.article.owner_tag_list")
              b-tag(@click="tag_handle(tag)") {{tag}}
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
    tag_handle(tag) {
      this.$router.push({name: 'library-articles', query: {tag: tag}})
    },
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
    // lineage_info() { return this.base.LineageInfo.fetch(this.article.lineage_key) },
  },
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkArticleShowForm
  +mobile
    --gap: calc(#{$wkbk_share_gap} * 0.75)
  +tablet
    --gap: #{$wkbk_share_gap}

  margin: var(--gap)

  .field:not(:first-child)
    margin-top: var(--gap)
</style>
