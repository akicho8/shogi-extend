<template lang="pug">
.XmovieIndexCardList.columns.is-multiline
  .column.is-one-quarter-widescreen.is-one-third-desktop.is-half-tablet(v-for="e in base.xmovie_records")
    //- https://bulma.io/documentation/components/card/
    nuxt-link.card.is-block(:to="{name: 'video-xmovie_records-xmovie_record_key', params: {xmovie_record_key: e.key}}" @click.native="sound_play('click')")
      .card-image
        figure.image
          img(:src="e.avatar_path" :alt="e.title")
          .position_top_right
            b-tag(rounded type="is-dark")
              | {{e.xmovie_recordships_count}}
      .card-content
        .media
          .media-left
            figure.image.is-48x48
              img.is-rounded(:src="e.user.avatar_path" :alt="e.user.name")
          .media-content
            .title.is-5.mb-1 {{e.title}}
            p {{e.user.name}}
            p
              | {{updated_time_format(e.updated_at)}}
              b-icon.ml-1(:icon="FolderInfo.fetch(e.folder_key).icon" size="is-small" v-if="e.folder_key != 'public'")
            XmovieTagList.mt-1(:tag_list="e.tag_list" :tag_search_handle="base.tag_search_handle" v-if="XmovieConfig.value_of('top_tag_display_p')")

        .content(v-if="false")
          .description.is_truncate2(v-html="simple_format(auto_link(e.description))")
</template>

<script>
import { support_child } from "./support_child.js"
export default {
  name: "XmovieIndexCardList",
  mixins: [
    support_child,
  ],
}
</script>

<style lang="sass">
@import "../support.sass"
+mobile
  .XmovieIndexCardList.columns
    margin-bottom: 0
    .column
      padding: 0
      &:not(:first-child)
        margin-top: 0.75rem

.XmovieIndexCardList
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
