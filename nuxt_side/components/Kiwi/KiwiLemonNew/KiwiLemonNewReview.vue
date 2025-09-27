<template lang="pug">
.KiwiLemonNewReview.column.is-half(v-if="base.done_record")
  b-message(type="is-danger" v-if="base.done_record.errored_at")
    | {{base.done_record.error_message}}

  b-notification(:closable="true" type="is-danger" v-if="base.done_record.errored_at && development_p && false")
    | {{base.done_record.error_message}}

  template(v-if="base.done_record.successed_at")
    .is_review_box
      .media_container
        template(v-if="base.done_record.recipe_info.file_type === 'video'")
          video(:src="base.done_record.browser_path" controls :autoplay="false" :loop="false")
        template(v-if="base.done_record.recipe_info.file_type === 'image'")
          img(:src="base.done_record.browser_path")
      template(v-if="base.done_record.recipe_info.file_type === 'zip'")
        b-icon(icon="zip-box-outline" size="is-large")

    .buttons.is-flex-wrap-nowrap.is-centered.mt-3
      b-button.has-text-weight-bold(@click="base.download_talk_handle" tag="a" :href="base.done_record.browser_path"            type="is-primary" icon-left="download"    :download="base.done_record.filename_human") ダウンロード
      b-button(@click="base.banana_new_handle(base.done_record)"            type=""                                      icon-left="upload")
      b-button(v-if="development_p" @click="sfx_play_click()" tag="a" :href="base.done_record.browser_path"            type=""           icon-left="eye-outline" target="_blank" )
      b-button(v-if="development_p" @click="base.rails_attachment_show_handle(base.done_record)"     type="is-light"   icon-left="download"            )
      b-button(v-if="development_p" @click="base.rails_inline_show_test_handle(base.done_record)"         type="is-light"   icon-left="eye-outline"         )
      b-button(v-if="development_p" @click="base.other_window_open_if_pc_handle(base.done_record)"       type="is-light"   icon-left="link"                )
      b-button(v-if="development_p" @click="base.media_info_show_handle(base.done_record)"  type="is-light"   icon-left="information-variant" )
      b-button(v-if="development_p" @click="base.json_show_handle(base.done_record)"         type="is-light"   icon-left="code-json"           )
      b-button(v-if="development_p" @click="base.close_handle"                               type=""           icon-left="close"                 )
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "KiwiLemonNewReview",
  mixins: [support_child],
  computed: {
  },
}
</script>

<style lang="sass">
.KiwiLemonNewReview
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
    // .media_container
    //   > *:not(:fullscreen)
    //     border: 1px solid $grey-lighter
    //     border-radius: 4px

    // video
    //   width: 100vw
    //   // width: 1024px
    //   // width: inherit
    //   // height: inherit
    //   aspect-ratio: attr(width) / attr(height)

  .message
    word-break: break-all
</style>
