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
        template(v-if="['mp4', 'mov'].includes(to_format)")
          video(:src="base.done_record.browser_url" controls autoplay loop_key)
        template(v-else)
          img(:src="base.done_record.browser_url")

      .buttons.mb-0.is-centered.mt-4(v-if="development_p || true")
        b-button.mb-0(@click="base.close_handle" v-if="development_p") 戻る
        b-button.mb-0.has-text-weight-bold(@click="base.download_handle" type="is-primary" icon-left="download") ダウンロード
        b-button.mb-0(@click="base.direct_link_handle" icon-left="link") 直リン
        b-button.mb-0(@click="base.other_window_open_handle" icon-left="open-in-new") 別で開く
        b-button.mb-0(@click="base.json_show_handle") JSON

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
    to_format() { return this.base.done_record?.convert_params.board_binary_generator_params.to_format },
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
      max-width: 600px

    display: flex
    justify-content: center
    align-items: center

    // フルスクリーンでは装飾しない
    > *:not(:fullscreen)
      border: 2px solid $grey-lighter
      border-radius: 4px
</style>
