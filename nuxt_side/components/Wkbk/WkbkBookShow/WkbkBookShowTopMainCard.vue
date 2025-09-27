<template lang="pug">
.WkbkBookShowTopMainCard
  .card.is-block
    .card-image
      figure.image
        img(:src="base.book.avatar_path" :alt="base.book.title")
        .position_on_image
          b-tag(rounded type="is-dark")
            | {{base.book.bookships_count}}
    .card-content
      .media
        .media-left
          nuxt-link.image.is-48x48.is-clickable(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sfx_click()")
            img.is-rounded(:src="base.book.user.avatar_path" :alt="base.book.user.name")
        .media-content
          //- p(v-if="base.book.tag_list.length >= 1")
          //-   span.tag_links
          //-     template(v-for="tag in base.book.tag_list")
          //-       a.has-text-link(@click.prevent.stop="base.tag_search_handle(tag)" :key="`${base.book.key}_${tag}`") \#{{tag}}
          .title.is-4.mb-1 {{base.book.title}}
          .mt-1.is_line_break_on.has-text-grey.is-size-6
            nuxt-link(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sfx_click()")
              | {{base.book.user.name}}
            span.ml-2 {{$time.format_diff(base.book.updated_at)}}

            b-icon.ml-2(icon="eye-outline" size="is-small")
            span.ml-1 {{base.book.access_logs_count}}

            b-icon.ml-2(:icon="FolderInfo.fetch(base.book.folder_key).icon" size="is-small" v-if="base.book.folder_key != 'public'")

          WkbkTagList.mt-1(:tag_list="base.book.tag_list" :tag_search_handle="base.tag_search_handle")

          .content.mt-4(v-if="base.book.description")
            .description(v-html="$gs.simple_format($gs.auto_link(base.book.description))")
    .card-footer
      //- .card-footer-item
      //-   b-button.has-text-weight-bold(type="is-primary" @click="base.play_start")
      //-     | START
      .card-footer-item.has-text-weight-bold.is-clickable.has-background-primary.has-text-white.play_start_handle(@click="base.play_start")
        | START
      //- nuxt-link.card-footer-item(:to="{name: 'rack-articles-new', query: {book_key: base.book.key}}"        @click.native="sfx_click()" v-if="base.owner_p") 問題追加
      //- nuxt-link.card-footer-item(:to="{name: 'rack-books-book_key-edit', params: {book_key: base.book.key}}" @click.native="sfx_click()" v-if="base.owner_p") 編集
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowTopMainCard",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.STAGE-development
  .WkbkBookShowTopMainCard
    __css_keep__: 0

.WkbkBookShowTopMainCard
  .card-image
    // 個数
    .position_on_image
      position: absolute
      top: 0
      left: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .hashtags
    a:not(:first-child)
      margin-left: 0.25rem

  .media-content
    p
      line-height: 1.25rem
</style>
