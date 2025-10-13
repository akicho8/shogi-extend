<template lang="pug">
.KiwiBananaInfo.media
  .media-left
    .image.is-square
      img.is-rounded(:src="banana.user.avatar_path" :alt="banana.user.name")

  .media-content
    .title.is_line_break_on.mb-0 {{banana.title}}

    .mt-1.is_line_break_on.has-text-grey.is_body
      | {{banana.user.name}}

      span.ml-2 {{$time.format_diff(banana.updated_at)}}

      p
        b-icon(icon="eye-outline" size="is-small")
        span.ml-1 {{banana.access_logs_count}}

        b-icon.ml-2(icon="comment-outline" size="is-small")
        span.ml-1 {{banana.banana_messages_count}}

        b-icon.ml-2(:icon="banana.folder_info.icon" size="is-small" v-if="banana.folder_info.key != 'public'")
</template>

<script>
import { all_support } from "./all_support.js"

export default {
  name: "KiwiBananaInfo",
  mixins: [all_support],
  props: {
    base: { type: Object, required: true, },
    banana: { type: Object, required: true, },
  },
  mounted() {
    this.$GX.assert(this.$GX.present_p(this.banana), "this.$GX.present_p(this.banana)")
  },
}
</script>

<style lang="sass">
@import "./all_support.sass"
.KiwiBananaInfo
  .media-content
    overflow: visible // mobileにしたとき overflow-x: scroll にされてしまいグラグラするのを防ぐ

  .image
    width: 24px

  .media-content
    .title
      font-size: unset

    +tablet
      font-size: $size-7
</style>
