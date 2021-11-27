<template lang="pug">
.WkbkTopContent.columns.is-multiline
  .column.is-4-tablet.is-3-desktop.is-2-widescreen(v-for="e in base.books")
    //- https://bulma.io/documentation/components/card/
    nuxt-link.card.is-block(:to="{name: 'rack-books-book_key', params: {book_key: e.key}}" @click.native="sound_play_click()")
      .card-image
        figure.image
          img(:src="e.avatar_path" :alt="e.title")
          .position_top_right
            b-tag(rounded type="is-dark")
              | {{e.bookships_count}}
      .card-content
        .media
          .media-left
            .image.is-square
              img.is-rounded(:src="e.user.avatar_path" :alt="e.user.name")
          .media-content
            .title.is_line_break_on.mb-0 {{e.title}}
            .mt-1.is_line_break_on.has-text-grey.is_body.is-size-7
              | {{e.user.name}}
              span.ml-2 {{updated_time_format(e.updated_at)}}
              b-icon.ml-2(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small" v-if="e.folder_key != 'public'")
            WkbkTagList.mt-1(:tag_list="e.tag_list" :tag_search_handle="base.tag_search_handle" v-if="WkbkConfig.value_of('top_tag_display_p')")

        .content(v-if="false")
          .description.is_truncate2(v-html="simple_format(auto_link(e.description))")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "WkbkTopContent",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
+mobile
  .WkbkTopContent.columns
    margin-bottom: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

.WkbkTopContent
  .user_avatar
    img
      max-height: none
      height: 18px
      width:  18px
  .card-image
    // 個数
    .position_top_right
      position: absolute
      top: 0
      right: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .media-content
    overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

  .card-content
    .image
      width: 24px

  .media-content
    .title
      font-size: unset

    // +tablet
    //   font-size: $size-7

  .hashtags
    span:not(:first-child)
      margin-left: 0.25rem

  .media-content
    p
      line-height: 1.25rem
</style>
