<template lang="pug">
.XconvPreview.columns(v-if="base.done_record")
  .column
    //- b-message.mt-4(title="失敗" :closable="false" type="is-warning" v-if="base.done_record.errored_at")
    //-   | {{base.done_record.error_message}}
    b-notification.mt-4(:closable="false" type="is-danger" v-if="base.done_record.errored_at")
      | {{base.done_record.error_message}}

    template(v-if="base.done_record.successed_at")
      .box
        b-image(:src="base.done_record.browser_url")

      .buttons.is-centered.mb-0(v-if="development_p || true")
        b-button.mb-0(@click="base.close_handle" v-if="development_p") 戻る
        b-button.mb-0(@click="base.download_handle" type="is-primary") ダウンロード
        b-button.mb-0(@click="base.other_window_open_handle" type="is-primary") 別Windowで開く
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "XconvPreview",
  mixins: [support_child],
}
</script>

<style lang="sass">
.XconvPreview
</style>
