<template lang="pug">
.WkbkTopContent.columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
  .column.is-12
    .buttons.are-small.is_buttons_scroll
      template(v-for="e in base.SearchPresetInfo.values")
        b-button(v-if="e.showable_p(g_current_user)" @click="base.search_preset_handle(e)" :type="{'is-primary': base.search_preset_info.key === e.key}")
          | {{e.name}}

  WkbkTopTagList(:base="base")

  .column.is-4-tablet.is-3-desktop.is-2-widescreen(v-for="e in base.books")
    //- https://bulma.io/documentation/components/card/
    nuxt-link.card.is-block(:to="{name: 'rack-books-book_key', params: {book_key: e.key}}" @click.native="sfx_click()")
      .card-image
        figure.image
          img(:src="e.avatar_path" :alt="e.title")
          .position_on_image
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
              span.ml-2 {{$time.format_diff(e.updated_at)}}
              p
                b-icon(icon="eye-outline" size="is-small")
                span.ml-1 {{e.access_logs_count}}
                b-icon.ml-2(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small" v-if="e.folder_key != 'public'")

        .content(v-if="false")
          .description.is_truncate2(v-html="$gs.simple_format($gs.auto_link(e.description))")

  .column.is-12(v-if="base.xpage_info")
    //- テーブルのページネーションに合わせとく
    .level
      .level-left
        .level-item
      .level-right
        .level-item
          b-pagination(
            :total="base.xpage_info.total_count"
            :per-page="base.xpage_info.limit_value"
            :current="base.xpage_info.current_page"
            @change="base.page_change_handle"
            order="is-right"
            simple
            )

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
// +mobile
//   .WkbkTopContent.columns
//     margin-bottom: 0
//     .column
//       padding: 0
//       &:not(:first-child)
//         margin-top: 0.75rem

.WkbkTopContent
  .user_avatar
    img
      max-height: none
      height: 18px
      width:  18px
  .card-image
    // 個数
    .position_on_image
      position: absolute
      top: 0
      left: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .media-content
    overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

  .card-content
    padding: 1rem

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
