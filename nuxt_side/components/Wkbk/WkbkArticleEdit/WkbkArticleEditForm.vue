<template lang="pug">
MainSection.WkbkArticleEditForm
  .container
    .columns
      .column
        b-field.article_title(label="タイトル" label-position="on-border")
          b-input(v-model.trim="base.article.title" :maxlength="100" placeholder="空でもかまいません")

        b-field(label="解説" label-position="on-border")
          b-input(v-model.trim="base.article.description" type="textarea" :maxlength="5000" placeholder="解答者に向けて問題の解答の解説をしましょう")

        b-field(label="種類" label-position="on-border" v-if="base.LineageInfo")
          b-select(v-model="base.article.lineage_key" expanded)
            option(v-for="e in base.LineageInfo.values" :value="e.key")
              | {{e.name}}

        b-field(label="出題時の一言" label-position="on-border")
          b-input(v-model.trim="base.article.direction_message" placeholder="タイトルとは別に一言添えたいときの文言です (省略可)")

        b-field(label="難易度" custom-class="is-small")
          b-rate(v-model="base.article.difficulty" spaced :max="5" :show-score="false")

        b-field(v-if="development_p")
          b-switch(v-model="base.article.mate_skip" :disabled="!lineage_info.mate_validate_on")
            span 最後は無駄合い
            span.has-text-grey.is-size-7.ml-1 なので詰みチェックを省略

        b-field(label="タグ" label-position="on-border")
          //- https://buefy.org/documentation/taginput
          b-taginput(v-model="base.article.tag_list" rounded :on-paste-separators="[',', ' ']" :confirm-keys="[',', 'Tab', 'Enter']")

        b-field(label="公開設定" custom-class="is-small" :message="FolderInfo.fetch(base.article.folder_key).message.article")
          b-field.is-marginless
            template(v-for="e in FolderInfo.values")
              b-radio-button(v-model="base.article.folder_key" :native-value="e.key" expanded)
                b-icon(:icon="e.icon" size="is-small")
                span {{e.name}}

        .box(v-if="false")
          b-field(label="この問題を入れる問題集" custom-class="is-medium")
            .control.book_cb_buttons
              template(v-for="e in base.books")
                b-field
                  b-checkbox-button(v-model="base.article.book_keys" :native-value="e.key")
                    b-icon.ml-1(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small")
                    p {{e.title}}
      .column.is-one-third
        .panel.mb-0
          .panel-heading
            | この問題を入れる問題集
          template(v-if="base.books.length >= 1")
            .panel-block.book_cb_buttons.is-block
              template(v-for="e in base.books")
                b-field
                  b-checkbox-button(v-model="base.article.book_keys" :native-value="e.key" expanded @input="sfx_click()")
                    b-icon(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small")
                    p.ml-2 {{e.title}}
          .panel-block.py-4
            nuxt-link.is-size-7(:to="{name: 'rack-books-new'}" @click.native="sfx_click()")
              b-icon(icon="plus" size="is-small")
              span.ml-1 新しい問題集
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
        this.sfx_click()
        this.talk(v)
      },
    },
    "article.mate_skip": {
      handler(v) {
        this.sfx_click()
        this.talk(v)
      },
    },
    "article.difficulty": {
      handler(v) {
        this.sfx_click()
        this.talk(v)
      },
    },
    "article.folder_key": {
      handler(v) {
        const folder_info = this.FolderInfo.fetch(v)
        this.sfx_click()
        this.sfx_stop_all()
        this.talk(folder_info.name)
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
.MainSection.section.WkbkArticleEditForm
  +mobile
    padding: 1.0rem
  +tablet
    padding: 1.5rem

  .field:not(:last-child)
    margin-bottom: 1.5rem

  .book_cb_buttons
    padding-top: 1rem
    padding-bottom: 1rem
    .field
      &:not(:last-child)
        margin-bottom: 0.75rem
      .button
        justify-content: flex-start

  .help
    color: $grey
    font-size: $size-7

  // // iPhoneでselectをタップするとズームするのはフォントサイズが16px未満だから
  // +touch
  //   input, textarea, select
  //     font-size: 16px
</style>
