<template lang="pug">
.KiwiBookInfo.media(:class="type")
  .media-left
    template(v-if="type === 'is_full'")
      nuxt-link.image(:class="image_class" :to="{name: 'users-id', params: {id: book.user.id}}" @click.native="sound_play('click')")
        img.is-rounded(:src="book.user.avatar_path" :alt="book.user.name")
    template(v-else)
      .image(:class="image_class")
        img.is-rounded(:src="book.user.avatar_path" :alt="book.user.name")

  .media-content
    .title.is_line_break_on.mb-0(:class="title_class") {{book.title}}

    .mt-1.is_line_break_on.has-text-grey
      template(v-if="type === 'is_full'")
        nuxt-link(:to="{name: 'users-id', params: {id: book.user.id}}" @click.native="sound_play('click')") {{book.user.name}}
      template(v-else)
        | {{book.user.name}}

      //- span.ml-1 {{updated_time_format(book.updated_at)}}
      span.ml-1 {{diff_time_format(book.updated_at)}}
      b-icon.ml-1(:icon="book.folder_info.icon" size="is-small" v-if="book.folder_info.key != 'public'")

    template(v-if="type === 'is_full'")
      KiwiTagList.mt-2(:tag_list="book.tag_list" :tag_append_search_handle="base.tag_append_search_handle")
      .content.mt-1(v-if="book.description")
        .description(v-html="simple_format(auto_link(book.description))")
</template>

<script>
import { all_support } from "./all_support.js"

export default {
  name: "KiwiBookInfo",
  mixins: [all_support],
  props: {
    base: { type: Object, required: true,                       },
    book: { type: Object, required: true,                       },
    type: { type: String, required: false, default: "is_full",  }, // is_full or is_compact
  },

  computed: {
    title_class() {
      return {
        "is-5": this.type === "is_full",
        "is-6": this.type === "is_compact",
      }
    },
    image_class() {
      return {
        "is-48x48": this.type === "is_full",
        "is-24x24": this.type === "is_compact",
      }
    },
  },
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiBookInfo
  .media-content
    overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ
</style>
