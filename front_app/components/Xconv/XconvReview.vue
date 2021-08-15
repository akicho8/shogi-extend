<template lang="pug">
.XconvReview.column.is-half(v-if="base.done_record")
  b-notification(:closable="false" type="is-danger" v-if="base.done_record.errored_at")
    | {{base.done_record.error_message}}

  template(v-if="base.done_record.successed_at")
    .is_review_box
      template(v-if="base.done_record.xout_format_info.respond_html_tag === 'video'")
        video(:src="base.done_record.rails_side_inline_url" controls autoplay loop)
      template(v-else)
        img(:src="base.done_record.rails_side_inline_url")

    .buttons.has-addons.is-centered.mt-4
      b-button(@click="base.main_download_handle(base.done_record)"     icon-left="download" type="is-primary")
      b-button(@click="base.main_show_handle(base.done_record)"         icon-left="eye-outline")
      b-button(@click="base.secret_show_handle(base.done_record)"       icon-left="link" v-if="development_or_staging_p")
      b-button(@click="base.probe_show_modal_handle(base.done_record)"  icon-left="information-variant")
      b-button(@click="base.json_show_handle(base.done_record)"         icon-left="code-json" v-if="development_p")
      b-button(@click="base.close_handle"                               icon-left="close")

  b-message.mt-5(v-if="base.done_record.ffprobe_info && false")
    | {{JSON.stringify(base.done_record.ffprobe_info.pretty_format.streams[0], null, 4)}}

  template(v-if="base.done_record.successed_at && false")
    pre
      | {{base.done_record.browser_url}}
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
    > *:not(:fullscreen)
      border: 2px dashed $grey-lighter
      border-radius: 4px

  .message
    white-space: pre-wrap
    word-break: break-all
</style>
