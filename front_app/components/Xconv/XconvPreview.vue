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
          video(:src="base.done_record.browser_url" controls autoplay loop)
        template(v-else)
          img(:src="base.done_record.browser_url")

      .buttons.is-centered.mb-0(v-if="development_p || true")
        b-button.mb-0(@click="base.close_handle" v-if="development_p") 戻る
        b-button.mb-0(@click="base.download_handle" type="is-primary") ダウンロード
        b-button.mb-0(@click="base.direct_link_handle" type="is-primary") 直リンク
        b-button.mb-0(@click="base.json_show_handle" type="is-primary") JSON
        b-button.mb-0(@click="base.other_window_open_handle" type="is-primary") 別Windowで開く

    template(v-if="base.done_record.successed_at")
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
  .is_preview_box
    max-width: 600

    display: flex
    justify-content: center
    align-items: center
    > *:not(:fullscreen)
      border: 2px solid $grey-lighter
      border-radius: 4px
</style>
