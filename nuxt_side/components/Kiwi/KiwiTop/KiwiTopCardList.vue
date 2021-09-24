<template lang="pug">
.KiwiTopCardList
  .columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
    .column.is-12
      .buttons.mb-0
        template(v-for="e in base.SearchCategoryInfo.values")
          b-button.mb-0(@click="base.search_by_category(e)") {{e.name}}

    .column.is-4-tablet.is-3-desktop.is-2-widescreen(v-for="e in base.books")
      nuxt-link.card(:to="{name: 'video-books-book_key', params: {book_key: e.key}}" @click.native="sound_play('click')")
        .card-image
          figure.image
            img(:src="e.lemon.thumbnail_browser_path")
        .card-content
          .media
            .media-left
              figure.image.is-48x48
                img.is-rounded(:src="e.user.avatar_path" :alt="e.user.name")
            .media-content
              p.has-text-weight-bold.is-size-5(v-if="present_p(e.title)") {{e.title}}
              //- <p class="subtitle is-6">@johnsmith</p>
              p(v-if="present_p(e.description)") {{e.description}}
              p.has-text-grey.is-size-7
                span {{e.user.name}}
                span.mx-1 {{row_time_format(e.created_at)}}

          //- .content
          //-   | {{e.description}}
          //-   //- | Lorem ipsum dolor sit amet, consectetur adipiscing elit.
          //-   //- | Phasellus nec iaculis mauris. <a>@bulmaio</a>.
          //-   //- <a href="#">#css</a> <a href="#">#responsive</a>
          //-   br
          //-   time
          //-     | {{row_time_format(e.created_at)}}

      //- .card-content
      //-   .media
      //-     .media-left
      //-       figure.image.is-48x48
      //-         img.is-rounded(:src="e.user.avatar_path" :alt="e.user.name")
      //-     .media-content
      //-       .title.is-5.mb-1 {{e.title}}
      //-       p {{e.user.name}}
      //-       p
      //-         | {{updated_time_format(e.updated_at)}}
      //-         b-icon.ml-1(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small" v-if="e.folder_key != 'public'")
      //-       KiwiTagList.mt-1(:tag_list="e.tag_list" :tag_search_handle="base.tag_search_handle" v-if="KiwiConfig.value_of('top_tag_display_p')")
      //-
      //-   .content(v-if="false")
      //-     .description.is_truncate2(v-html="simple_format(auto_link(e.description))")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "KiwiTopCardList",
  mixins: [
    support_child,
  ],
  methods: {
  },

}
</script>

<style lang="sass">
@import "../support.sass"

+mobile
  .KiwiTopCardList.columns
    margin-bottom: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

.KiwiTopCardList
  .user_avatar
    img
      max-height: none
      height: 18px
      width:  18px

  .hashtags
    span:not(:first-child)
      margin-left: 0.25rem

  .media-content
    // p
    //   line-height: 1.25rem
</style>
