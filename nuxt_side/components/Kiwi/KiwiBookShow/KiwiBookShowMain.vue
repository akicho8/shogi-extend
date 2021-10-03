<template lang="pug">
.KiwiBookShowMain.columns.is-multiline.is-variable.is-0-mobile.is-4-tablet.is-5-desktop.is-6-widescreen.is-7-fullhd
  .column.is-12-tablet.is-10-desktop.is-8-widescreen
    .block
      template(v-if="content_type.startsWith('video')")
        .image
          video.is-block(:src="base.book.lemon.browser_path" :poster="base.book.lemon.thumbnail_browser_path" controls :autoplay="true" :loop="false")
      template(v-else-if="content_type.startsWith('image')")
        .image
          img(:src="base.book.lemon.browser_path")
      template(v-else-if="content_type === 'application/zip'")
        b-icon(icon="zip-box-outline" size="is-large")
      template(v-else)
        p content_type: {{content_type}}
        p browser_path: {{base.book.lemon.browser_path}}

    .media
      .media-left
        nuxt-link.image.is_avatar_image(:class="image_class" :to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
          img.is-rounded(:src="base.book.user.avatar_path" :alt="base.book.user.name")

      .media-content
        .title.is_line_break_on.mb-0.is-5 {{base.book.title}}

        .mt-2.is_line_break_on.has-text-grey
          nuxt-link(:to="{name: 'users-id', params: {id: base.book.user.id}}" @click.native="sound_play('click')")
            | {{base.book.user.name}}
          //- span.ml-1 {{updated_time_format(base.book.updated_at)}}
          span.ml-1 {{diff_time_format(base.book.updated_at)}}

          b-icon.ml-2(icon="eye-outline" size="is-small")
          span.ml-1 {{base.book.access_logs_count}}

          b-icon.ml-2(icon="comment-outline" size="is-small")
          span.ml-1 {{base.book.book_messages_count}}

          b-icon.ml-2(:icon="base.book.folder_info.icon" size="is-small" v-if="base.book.folder_info.key != 'public'")

        KiwiTagList.mt-2(:tag_list="base.book.tag_list" :tag_append_search_handle="base.tag_append_search_handle")
        .content.mt-1(v-if="base.book.description")
          .description(v-html="simple_format(auto_link(base.book.description))")

  .column
     KiwiBookShowMessage(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiBookShowMain",
  mixins: [support_child],
  mounted() {
    this.__assert__(this.present_p(this.base.book), "this.present_p(this.base.book)")
  },
  computed: {
    content_type() { return this.base.book.lemon.content_type },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.KiwiBookShowMain
  .is_avatar_image
    width: 32px
    +tablet
      width: 48px
</style>
