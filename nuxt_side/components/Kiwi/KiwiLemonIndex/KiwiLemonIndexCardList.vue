<template lang="pug">
.KiwiLemonIndexCardList
  .columns.is-multiline.is-variable.is-0-mobile.is-1-tablet.is-2-desktop.is-3-widescreen
    .column.is-12
      .buttons.mb-0
        template(v-for="e in base.SearchCategoryInfo.values")
          b-button.mb-0(@click="base.search_by_category(e)") {{e.name}}

    .column.is-6-tablet.is-4-desktop.is-4-widescreen(v-for="e in base.lemons")
      .card
        .card-image
          figure.image
            video.is-block(:src="e.browser_path" controls :autoplay="false" :loop="false" v-bind="e.video_tag_attrs" @click="foo_handle")
        .card-content
          .media
            .media-left
              figure.image.is-48x48
                img(:src="e.user.avatar_path" :alt="e.user.name")
            .media-content
              <p class="title is-4">John Smith</p>
              <p class="subtitle is-6">@johnsmith</p>
          .content
            | Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            | Phasellus nec iaculis mauris. <a>@bulmaio</a>.
            <a href="#">#css</a> <a href="#">#responsive</a>
            <br>
            <time datetime="2016-1-1">11:09 PM - 1 Jan 2016</time>

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
  name: "KiwiLemonIndexCardList",
  mixins: [
    support_child,
  ],
  methods: {
    foo_handle(e) {
    },
  },

}
</script>

<style lang="sass">
@import "../support.sass"
+mobile
  .KiwiLemonIndexCardList.columns
    margin-bottom: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

.KiwiLemonIndexCardList
  .user_avatar
    img
      max-height: none
      height: 18px
      width:  18px
  .card-image
    figure.image

    // 個数
    .position_top_right
      position: absolute
      top: 0
      right: 0
      .tag
        margin: 6px
        background-color: change_color($black, $alpha: 0.5)

  .hashtags
    span:not(:first-child)
      margin-left: 0.25rem

  .media-content
    p
      line-height: 1.25rem
</style>
