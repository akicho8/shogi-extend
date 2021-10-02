<template lang="pug">
.KiwiBookInfo.media
  .media-left
    .image.is-square
      img.is-rounded(:src="book.user.avatar_path" :alt="book.user.name")

  .media-content
    .title.is_line_break_on.mb-0.is-6 {{book.title}}

    .mt-1.is_line_break_on.has-text-grey
      | {{book.user.name}}

      span.ml-2 {{diff_time_format(book.updated_at)}}

      p
        b-icon(icon="eye" size="is-small")
        span.ml-1 {{book.access_logs_count}}

        b-icon.ml-2(:icon="book.folder_info.icon" size="is-small" v-if="book.folder_info.key != 'public'")
</template>

<script>
import { all_support } from "./all_support.js"

export default {
  name: "KiwiBookInfo",
  mixins: [all_support],
  props: {
    base: { type: Object, required: true, },
    book: { type: Object, required: true, },
  },
  mounted() {
    this.__assert__(this.present_p(this.book), "this.present_p(this.book)")
  },
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiBookInfo
  .media-content
    overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

  .image
    width: 24px
</style>
