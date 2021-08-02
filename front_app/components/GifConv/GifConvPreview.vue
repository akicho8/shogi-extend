<template lang="pug">
.GifConvPreview.columns(v-if="base.owattayo_record")
  .column
    .box
      b-image(:src="base.owattayo_record.browser_full_path" alt="foo")
    .buttons.is-centered.mb-0
      b-button.mb-0(@click="base.close_handle") 戻る
      b-button.mb-0(@click="base.download_handle" type="is-primary") ダウンロード
      b-button.mb-0(@click="base.other_window_open_handle" type="is-primary") 別Windowで開く
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "GifConvPreview",
  mixins: [support_child],
}
</script>

<style lang="sass">
.GifConvPreview
</style>
