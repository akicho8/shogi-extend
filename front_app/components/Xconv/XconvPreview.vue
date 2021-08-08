<template lang="pug">
.XconvPreview.columns(v-if="base.done_record")
  .column
    //- b-message.mt-4(title="失敗" :closable="false" type="is-warning" v-if="base.done_record.errored_at")
    //-   | {{base.done_record.error_message}}
    b-notification.mt-4(:closable="false" type="is-danger" v-if="base.done_record.errored_at")
      | {{base.done_record.error_message}}

    template(v-if="base.done_record.successed_at")
      //- .box
      .is_preview_box
        template(v-if="xout_format_info.mime_group === 'video'")
          video(:src="base.done_record.browser_url" controls autoplay loop)
        template(v-else)
          img(:src="base.done_record.browser_url")

      .buttons.is-centered.mt-4(v-if="development_p || true")
        b-button(@click="base.close_handle" v-if="development_p") 戻る
        b-button.has-text-weight-bold(@click="base.download_handle" type="is-primary" icon-left="download") ダウンロード
        b-button(@click="base.direct_link_handle" icon-left="link") 直リン
        b-button(@click="base.other_window_open_handle" icon-left="open-in-new") 別で開く
        b-button(@click="base.json_show_handle") JSON

    b-message.mt-5(v-if="base.done_record.file_identify")
      | {{base.done_record.file_identify}}

    template(v-if="base.done_record.successed_at && false")
      pre
        | {{base.done_record.browser_url}}
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvPreview",
  mixins: [support_child],
  computed: {
    xout_format_key() { return this.base.done_record?.convert_params.board_binary_generator_params.xout_format_key },
    xout_format_info() { return this.base.XoutFormatInfo.fetch(this.xout_format_key) },
  },
}
</script>

<style lang="sass">
.XconvPreview
  margin-top: 1.5rem

  .is_preview_box
    // タブレット以上では小さく
    +tablet
      margin: auto
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
