<template lang="pug">
.XconvReview.column.is-half(v-if="base.done_record")
  b-message(type="is-danger" has-icon icon-size="is-medium" v-if="base.done_record.errored_at")
    | {{base.done_record.error_message}}

  b-notification(:closable="true" type="is-danger" v-if="base.done_record.errored_at && development_p")
    | {{base.done_record.error_message}}

  template(v-if="base.done_record.successed_at")
    .is_review_box
      .media_container
        template(v-if="base.done_record.recipe_info.file_type === 'video'")
          video(:src="base.done_record.rails_side_inline_url" controls :autoplay="false" :loop="false" v-bind="base.done_record.video_tag_attrs")
        template(v-if="base.done_record.recipe_info.file_type === 'image'")
          img(:src="base.done_record.rails_side_inline_url")
      template(v-if="base.done_record.recipe_info.file_type === 'zip'")
        b-icon(icon="zip-box-outline" size="is-large")

    .buttons.has-addons.is-centered.mt-3
      b-button(@click="base.main_download_handle(base.done_record)"     type="is-primary" icon-left="download")
      b-button(@click="base.main_show_handle(base.done_record)"         type=""           icon-left="eye-outline")
      b-button(@click="base.secret_show_handle(base.done_record)"       type="is-light"   icon-left="link"                v-if="development_or_staging_p")
      b-button(@click="base.probe_show_modal_handle(base.done_record)"  type="is-light"   icon-left="information-variant" v-if="development_or_staging_p")
      b-button(@click="base.json_show_handle(base.done_record)"         type="is-light"   icon-left="code-json"           v-if="development_or_staging_p")
      b-button(@click="base.close_handle"                               type=""           icon-left="close")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvReview",
  mixins: [support_child],
  computed: {
  },
}
</script>

<style lang="sass">
.XconvReview
  // margin-top: 1.5rem

  .is_review_box
    // タブレット以上では小さく
    // +tablet
    //   margin: auto
    //   max-width: 600px
    // max-width: 600px

    display: flex
    justify-content: center
    align-items: center

    // フルスクリーンでは装飾しない
    .media_container
      > *:not(:fullscreen)
        border: 1px solid $grey-lighter
        border-radius: 4px

    // video
    //   width: 100vw
    //   // width: 1024px
    //   // width: inherit
    //   // height: inherit
    //   aspect-ratio: attr(width) / attr(height)

  // .message
  // white-space: pre-wrap
  // word-break: break-all
  // .media-left
  //   .icon
  //     margin: auto
  // .media-content
  //   margin: auto
</style>
